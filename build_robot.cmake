########################################
### MASTER BUILD SCRIPT FOR ITK-SNAP ###
########################################
#
# This script is used to automate building of nightly and experimental ITK-SNAP
# binaries on various platforms. The script must be invoked with ctest (from CMake)
# as follows
#
# ctest -V -S cdash/build_robot.cmake,paulyimac-MacOS,Nightly
#
# Explanation of parameters:
#
#    paulyimac-MacOS  The name of the site where the build is being run. The
#                     site can be a computer or a virtual machine on a computer.
#                     The sites directory must contain a corresponding subdirectory
#                     (e.g., paulyimac-MacOS) with site-specific config files 
#                     global.cmake and build.cmake
#    Nightly          Type of Dashboard build to perform (Nightly,Experimental)
#
# What the script will do
# 
#    The script will build the ITK and VTK libraries (appropriate versions) and 
#    several branches of ITK-SNAP and C3D. It will send the results of the build 
#    to the ITK-SNAP Dashboard, located at itksnap.org/cdash
#

# Include some macro code
INCLUDE(${CTEST_SCRIPT_DIRECTORY}/include/macros.cmake)

# ---------------------------------------
# All products / branches included here
# ---------------------------------------
SET(EXTERNAL_PRODUCTS
  "itk v4.13.2"
  "itk v5.2.1"
  "vtk v6.3.0"
  "vtk v9.1.0"
  )

SET(INTERNAL_PRODUCTS
  "itksnap vtk9qt6"
  "itksnap master"
  "greedy master"
  "c3d master"
  "cmrep vtk9")

# ---------------------------------------
# Parse the parameter settings
# ---------------------------------------

# Make sure the required variables are set for the site
CHECK_SITE_VAR(IN_GLOBAL_MODEL)
CHECK_SITE_VAR(IN_SITE)
CHECK_SITE_VAR(GIT_UID)
CHECK_SITE_VAR(GIT_BINARY)
CHECK_SITE_VAR(CMAKE_BINARY_PATH)
CHECK_SITE_VAR(CONFIG_LIST)

# Make sure model is valid
IF(NOT ${IN_GLOBAL_MODEL} MATCHES "Nightly|Experimental|Continuous")
  MESSAGE(FATAL_ERROR "Unknown model ${IN_GLOBAL_MODEL}")
ENDIF()

# Check the existance of the site-specific cache/env script
SET(SITE_BUILD_SCRIPT ${CTEST_SCRIPT_DIRECTORY}/sites/${IN_SITE}/build.cmake)
if(NOT EXISTS ${SITE_BUILD_SCRIPT})
  MESSAGE(FATAL_ERROR "Site-specific script ${SITE_BUILD_SCRIPT} does not exist")
endif(NOT EXISTS ${SITE_BUILD_SCRIPT})

# Include the machine-specific info without a product
SET(IN_PRODUCT)

# Generate the build list
SET(BUILD_LIST)

IF(NOT PRODUCT_MASK)
  SET(PRODUCT_MASK ".*")
ENDIF(NOT PRODUCT_MASK)

# Add external products
IF(NOT SKIP_EXTERNAL)
  FOREACH(PROD ${EXTERNAL_PRODUCTS})
    IF(PROD MATCHES ${PRODUCT_MASK})
      SET(BUILD_LIST ${BUILD_LIST} "${PROD} Nightly")
    ENDIF(PROD MATCHES ${PRODUCT_MASK})
  ENDFOREACH(PROD)
ENDIF(NOT SKIP_EXTERNAL)

# Add internal products
FOREACH(PROD ${INTERNAL_PRODUCTS})
  IF(PROD MATCHES ${PRODUCT_MASK})
    SET(BUILD_LIST ${BUILD_LIST} "${PROD} ${IN_GLOBAL_MODEL}")
  ENDIF(PROD MATCHES ${PRODUCT_MASK})
ENDFOREACH(PROD)

MESSAGE("==================== PRODUCT LIST ====================")
FOREACH(PROD ${BUILD_LIST})
  MESSAGE(" --> ${PROD}")
ENDFOREACH(PROD)

# The build of each product is implemented as a function in order to
# have a clean scope for each product built
FUNCTION(BUILD_PRODUCT IN_PRODUCT IN_BRANCH IN_MODEL)

  # This variable keeps track of the number of configs already processed,
  # this is so that we skip continuous builds if there were no updates on
  # the first config but not on the second or consequent configs
  SET(FIRST_UPDATE ON)

  # Loop over the configs
  FOREACH(IN_CONFIG ${CONFIG_LIST})

    MESSAGE("--- CONFIG ${IN_CONFIG} ---")

    # We now allow configs to have an optional part, specified as gcc64rel.qt4 
    # for example to specify that we want to set some flags differently for a
    # build. To facilitate this, we define the CONFIG_BASE and CONFIG_EXT vars
    # NOTE: only one extension is currently supported!
    unset(CONFIG_EXT)
    string(REPLACE "." ";" CONFIG_PART_LIST ${IN_CONFIG})
    list(LENGTH CONFIG_PART_LIST CONFIG_PART_LIST_LEN)
    list(GET CONFIG_PART_LIST 0 CONFIG_BASE)
    if(${CONFIG_PART_LIST_LEN} GREATER 1)
      list(GET CONFIG_PART_LIST 1 CONFIG_EXT)
    endif(${CONFIG_PART_LIST_LEN} GREATER 1)

    # Clear the SKIP flag
    UNSET(SKIP_BUILD)

    # Set some default options, so that we don't need to set them
    # separately for each site. Some sites may need to override this
    SET(CTEST_CMAKE_GENERATOR "Unix Makefiles")

    # By default, the ROOT of the build is set to the parent directory of
    # this script, but site can override this
    GET_FILENAME_COMPONENT(ROOT ${CTEST_SCRIPT_DIRECTORY} PATH)

    # Set the site name
    SET(CTEST_SITE ${IN_SITE})

    # Set the build name 
    SET(CTEST_BUILD_NAME "${CMAKE_SYSTEM}-${IN_BRANCH}-${IN_CONFIG}")

    # Include the product-specific scripts. These scripts must set the following
    # variables:
    #
    #   PRODUCT_CHECKOUT_COMMAND: command used to checkout specific branch/tag of the product
    #                             using GIT or whatever other tool
    # 
    #   PRODUCT_EXTERNAL:         if set to ON, the product is treated as an external product
    #                             (e.g., ITK, VTK) and is not rebuilt nightly
    #
    #   NEED_XXXX:                specifies to the site-specific script that certain products
    #                             are needed, and hence the cache must be configured for them
    #                             (these are FLTK, QT4, QT5 for now)

    SET(PRODUCT_SCRIPT ${CTEST_SCRIPT_DIRECTORY}/products/${IN_PRODUCT}.cmake)
    IF(NOT EXISTS ${PRODUCT_SCRIPT})
      MESSAGE(FATAL_ERROR "Product-specific script ${PRODUCT_SCRIPT} does not exist")
    ENDIF(NOT EXISTS ${PRODUCT_SCRIPT})
    INCLUDE(${PRODUCT_SCRIPT})

    # Include the site-specific build script. 
    INCLUDE(${SITE_BUILD_SCRIPT})

    # The site-specific script may cancel the build
    IF(SKIP_BUILD)

      MESSAGE(WARNING "Site-specific script CANCELED the build")
    
    ELSE(SKIP_BUILD)

      # Add some cache variables that site-specific scripts don't need to set
      CACHE_ADD("CMAKE_GENERATOR:INTERNAL=${CTEST_CMAKE_GENERATOR}")
      CACHE_ADD("BUILDNAME:STRING=${CTEST_BUILD_NAME}")
      CACHE_ADD("SITE:STRING=${CTEST_SITE}")
      CACHE_ADD("SCP_USERNAME:STRING=${GIT_UID}")

      # Directories for this build
      SET (CTEST_SOURCE_DIRECTORY "${ROOT}/${IN_MODEL}/${IN_PRODUCT}/${IN_BRANCH}/${IN_PRODUCT}")
      SET (CTEST_BINARY_DIRECTORY "${ROOT}/${IN_MODEL}/${IN_PRODUCT}/${IN_BRANCH}/${IN_CONFIG}")

      # The maximum time a test can run before CTest kills it
      SET(CTEST_TEST_TIMEOUT 300)

      # Clear the binary directory for nightly builds
      IF((${IN_MODEL} MATCHES "Nightly" AND NOT PRODUCT_EXTERNAL) OR FORCE_CLEAN)
        CTEST_EMPTY_BINARY_DIRECTORY(${CTEST_BINARY_DIRECTORY})
        MESSAGE("Emptied the binary directory ***EMPTY***")
      ENDIF()

      # Configure for GIT
      set(CTEST_UPDATE_TYPE "git")
      set(CTEST_UPDATE_COMMAND ${GIT_BINARY})

      if(NOT EXISTS ${CTEST_SOURCE_DIRECTORY})
        file(MAKE_DIRECTORY ${CTEST_SOURCE_DIRECTORY})
        set(CTEST_CHECKOUT_COMMAND ${PRODUCT_CHECKOUT_COMMAND})
        MESSAGE("GIT COMMAND: ${CTEST_CHECKOUT_COMMAND}")
      endif(NOT EXISTS ${CTEST_SOURCE_DIRECTORY})

      # Write the initial config file
      file(WRITE ${CTEST_BINARY_DIRECTORY}/CMakeCache.txt ${INIT_CACHE})

      # Print out the initial cache
      MESSAGE("Initial Cache:")
      STRING(REPLACE "\n" ";" INIT_CACHE_LIST ${INIT_CACHE})
      FOREACH(CACHE_ENTRY ${INIT_CACHE_LIST})
        MESSAGE("   ${CACHE_ENTRY}")
      ENDFOREACH()

      # Start the build process
      MESSAGE("Running ctest_start")
      ctest_start(${IN_MODEL})

      MESSAGE("Running ctest_update")
      ctest_update(RETURN_VALUE UPDATE_COUNT)
      MESSAGE("UPDATE resulted in ${UPDATE_COUNT} updated files")

      # For continuous builds, if there are no updates, we don't keep trying to build
      IF(${UPDATE_COUNT} EQUAL 0 AND FIRST_UPDATE AND ${IN_MODEL} MATCHES "Continuous")
        IF(NOT FORCE_CONTINUOUS)
          MESSAGE("Aborting Continuous build due to no updates")
          RETURN()
        ENDIF()
      ENDIF()

      # This is no longer the first update
      SET(FIRST_UPDATE OFF)

      # Different rules for own and external products
      IF(PRODUCT_EXTERNAL)

        # Don't bother re-configuring external products
        MESSAGE("Running ctest_configure")
        ctest_configure()

        MESSAGE("Running ctest_build")
        ctest_build()

      ELSE(PRODUCT_EXTERNAL)

        SET(build_success 0)
        MESSAGE("Updating git submodules")
        execute_process(
          COMMAND "${CTEST_UPDATE_COMMAND}" submodule update --init
          WORKING_DIRECTORY "${CTEST_SOURCE_DIRECTORY}")

        MESSAGE("Running ctest_configure")
        ctest_configure(RETURN_VALUE configure_return)

        MESSAGE("Running ctest_build")
        IF(${configure_return} EQUAL 0)
          ctest_build(RETURN_VALUE build_return NUMBER_ERRORS build_errors)

          IF(${build_return} EQUAL 0 AND ${build_errors} EQUAL 0)
            SET(build_success 1)
            IF(NOT SKIP_TESTING)
              MESSAGE("Running ctest_test")
              ctest_test()
            ENDIF()
          ENDIF()
          
        ENDIF()

        MESSAGE("Running ctest_submit")
        ctest_submit()

        # For nightly builds that are uploaders
        if(DO_UPLOAD AND ${build_success} EQUAL 1)
          MESSAGE("*** BUILDING TARGET package ***")
          ctest_build(TARGET package APPEND)

          if(IN_GLOBAL_MODEL MATCHES "Nightly")
            MESSAGE("*** BUILDING TARGET ${IN_PRODUCT}_upload_nightly ***")
            ctest_build(TARGET ${IN_PRODUCT}_upload_nightly APPEND)
          elseif(IN_GLOBAL_MODEL MATCHES "Experimental")
            MESSAGE("*** BUILDING TARGET ${IN_PRODUCT}_upload_experimental ***")
            ctest_build(TARGET ${IN_PRODUCT}_upload_experimental APPEND)
          endif()
          
        endif()

      ENDIF(PRODUCT_EXTERNAL)

    ENDIF(SKIP_BUILD)

  ENDFOREACH(IN_CONFIG)

ENDFUNCTION(BUILD_PRODUCT)


# For each of the products perform the build
FOREACH(BUILD ${BUILD_LIST})

  SEPARATE_ARGUMENTS(${BUILD} UNIX_COMMAND "${BUILD}")
  LIST(GET ${BUILD} 0 IN_PRODUCT)
  LIST(GET ${BUILD} 1 IN_BRANCH)
  LIST(GET ${BUILD} 2 IN_MODEL)

  MESSAGE("==================================================")
  MESSAGE("PRODUCT ${IN_PRODUCT} BRANCH ${IN_BRANCH} MODEL ${IN_MODEL}")
  MESSAGE("==================================================")

    BUILD_PRODUCT(${IN_PRODUCT} ${IN_BRANCH} ${IN_MODEL})

ENDFOREACH(BUILD)
