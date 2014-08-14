########################################
### MASTER BUILD SCRIPT FOR ITK-SNAP ###
########################################
#
# This script is used to automate building of nightly and experimental ITK-SNAP
# binaries on various platforms. The script must be invoked with ctest (from CMake)
# with parameters specifying the build machine, the build configuration, and the 
# git branch of ITK-SNAP to be executed.
#
# Example Usage:
#
# ctest -V -S build_robot.cmake,itksnap,master,Nightly,paulyimac-MacOS,gcc64rel
#
# Explanation of parameters:
#
#    itksnap          The name of the product to build (typically itksnap)
#    master           The name of the GIT branch to build on
#    Nightly          Type of Dashboard build to perform (Nightly,Experimental)
#    paulyimac-MacOS  The name of the site where the build is being run. The
#                     site can be a computer or a virtual machine on a computer.
#                     The sites directory must contain a corresponding script
#                     (e.g., paulyimac-MacOS.cmake) with site-specific config.
#    gcc64rel         The build configuration (compiler, 32 or 64 bits, release
#                     or debug, etc.). This can be machine specific and is used
#                     to tell the build script what to do.
#
# What the script will do
# 
#    The script will create a source directory and a build directory. It will check
#    out (or update) code in the source directory, and configure CMake and build in
#    the build directory. It will send the results of the build to the ITK-SNAP
#    Dashboard, located at itksnap.org/cdash
#

# Include some macro code
INCLUDE(${CTEST_SCRIPT_DIRECTORY}/include/macros.cmake)

# ---------------------------------------
# Parse the parameter settings
# ---------------------------------------
STRING(REPLACE , " " PARAM_LIST ${CTEST_SCRIPT_ARG})
SEPARATE_ARGUMENTS(${PARAM_LIST} UNIX_COMMAND "${PARAM_LIST}")
LIST(GET ${PARAM_LIST} 0 IN_SITE)
LIST(GET ${PARAM_LIST} 1 IN_GLOBAL_MODEL)
LIST(LENGTH ${PARAM_LIST} NUM_PARAM)

# Check the number of parameters
IF(NOT ${NUM_PARAM} EQUAL 2)
 MESSAGE(FATAL_ERROR "Wrong number of parameters to the script. Read the docs in the script.")
ENDIF(NOT ${NUM_PARAM} EQUAL 2) 

# Make sure model is valid
IF(NOT (${IN_GLOBAL_MODEL} MATCHES "Nightly" OR ${IN_GLOBAL_MODEL} MATCHES "Experimental"))
  MESSAGE(FATAL_ERROR "Unknown model ${IN_GLOBAL_MODEL}, should be Nightly or Experimental")
ENDIF(NOT (${IN_GLOBAL_MODEL} MATCHES "Nightly" OR ${IN_GLOBAL_MODEL} MATCHES "Experimental"))

# Check the existance of the site-specific script
SET(SITE_SCRIPT ${CTEST_SCRIPT_DIRECTORY}/sites/${IN_SITE}/configs.cmake)
if(NOT EXISTS ${SITE_SCRIPT})
  MESSAGE(FATAL_ERROR "Site-specific script ${SITE_SCRIPT} does not exist")
endif(NOT EXISTS ${SITE_SCRIPT})

# Check the existance of the site-specific cache/env script
SET(SITE_BUILD_SCRIPT ${CTEST_SCRIPT_DIRECTORY}/sites/${IN_SITE}/build.cmake)
if(NOT EXISTS ${SITE_BUILD_SCRIPT})
  MESSAGE(FATAL_ERROR "Site-specific script ${SITE_BUILD_SCRIPT} does not exist")
endif(NOT EXISTS ${SITE_BUILD_SCRIPT})

# Include the machine-specific info without a product
SET(IN_PRODUCT)
INCLUDE(${SITE_SCRIPT})

# Make sure the required variables are set for the site
CHECK_SITE_VAR(CONFIG_LIST)
CHECK_SITE_VAR(GIT_UID)
CHECK_SITE_VAR(GIT_BINARY)

# Set the list of products
SET(BUILD_LIST
  "itk v4.2.1 Nightly"
  "itk v4.5.2 Nightly"
  "vtk v5.8.0 Nightly"
  "vtk v6.0.0 Nightly"
  "itksnap dev32 ${IN_GLOBAL_MODEL}"
  "itksnap qtsnap ${IN_GLOBAL_MODEL}"
  "itksnap master ${IN_GLOBAL_MODEL}"
  "c3d master ${IN_GLOBAL_MODEL}")

# The build of each product is implemented as a function in order to
# have a clean scope for each product built
FUNCTION(BUILD_PRODUCT IN_PRODUCT IN_BRANCH IN_CONFIG IN_MODEL)

  # Set some default options, so that we don't need to set them
  # separately for each site. Some sites may need to override this
  SET(CTEST_CMAKE_GENERATOR "Unix Makefiles")

  # By default, the ROOT of the build is set to the parent directory of
  # this script, but site can override this
  GET_FILENAME_COMPONENT(ROOT ${CTEST_SCRIPT_DIRECTORY} PATH)

  # Set the site name
  SET(CTEST_SITE ${IN_SITE})

  # Set the build name 
  SET(CTEST_BUILD_NAME "${CMAKE_SYSTEM}-${IN_CONFIG}")

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
  IF(${IN_MODEL} MATCHES "Nightly" AND NOT PRODUCT_EXTERNAL)
    CTEST_EMPTY_BINARY_DIRECTORY(${CTEST_BINARY_DIRECTORY})
    MESSAGE("Emptied the binary directory ***EMPTY***")
  ENDIF(${IN_MODEL} MATCHES "Nightly" AND NOT PRODUCT_EXTERNAL)

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

  MESSAGE("Initial Cache ${INIT_CACHE}")
  ctest_start(${IN_MODEL})
  ctest_update()
  ctest_configure()
  ctest_build()

  if(NOT PRODUCT_EXTERNAL)
    ctest_test()
  ENDIF(NOT PRODUCT_EXTERNAL)

  ctest_submit()

  # For nightly builds that are uploaders
  if(NOT PRODUCT_EXTERNAL)
    if(DEFINED DO_UPLOAD)
      ctest_build(TARGET package APPEND)
      ctest_build(TARGET upload_nightly APPEND)
    endif(DEFINED DO_UPLOAD)
  endif(NOT PRODUCT_EXTERNAL)


ENDFUNCTION(BUILD_PRODUCT)


# For each of the products perform the build
FOREACH(IN_CONFIG ${CONFIG_LIST})
  FOREACH(BUILD ${BUILD_LIST})

    SEPARATE_ARGUMENTS(${BUILD} UNIX_COMMAND "${BUILD}")
    LIST(GET ${BUILD} 0 IN_PRODUCT)
    LIST(GET ${BUILD} 1 IN_BRANCH)
    LIST(GET ${BUILD} 2 IN_MODEL)

    MESSAGE("
        ========================================
        PRODUCT ${IN_PRODUCT} BRANCH ${IN_BRANCH} CONFIG ${IN_CONFIG} MODEL ${IN_MODEL}
        ========================================")

    BUILD_PRODUCT(${IN_PRODUCT} ${IN_BRANCH} ${IN_CONFIG} ${IN_MODEL})

  ENDFOREACH(BUILD)
ENDFOREACH(IN_CONFIG)
