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
LIST(GET ${PARAM_LIST} 0 IN_PRODUCT)
LIST(GET ${PARAM_LIST} 1 IN_BRANCH)
LIST(GET ${PARAM_LIST} 2 IN_MODEL)
LIST(GET ${PARAM_LIST} 3 IN_SITE)
LIST(GET ${PARAM_LIST} 4 IN_CONFIG)
LIST(LENGTH ${PARAM_LIST} NUM_PARAM)

# Check the number of parameters
IF(NOT ${NUM_PARAM} EQUAL 5)
 MESSAGE(FATAL_ERROR "Wrong number of parameters to the script. Read the docs in the script.")
ENDIF(NOT ${NUM_PARAM} EQUAL 5) 

# Make sure model is valid
IF(NOT (${IN_MODEL} MATCHES "Nightly" OR ${IN_MODEL} MATCHES "Experimental"))
  MESSAGE(FATAL_ERROR "Unknown model ${IN_MODEL}, should be Nightly or Experimental")
ENDIF(NOT (${IN_MODEL} MATCHES "Nightly" OR ${IN_MODEL} MATCHES "Experimental"))

# Check the existance of the site-specific script
SET(SITE_SCRIPT ${CTEST_SCRIPT_DIRECTORY}/sites/${IN_SITE}.cmake)
if(NOT EXISTS ${SITE_SCRIPT})
  MESSAGE(FATAL_ERROR "Site-specific script ${SITE_SCRIPT} does not exist")
endif(NOT EXISTS ${SITE_SCRIPT})

# Set some default options, so that we don't need to set them
# separately for each site. Some sites may need to override this
SET(CTEST_CMAKE_GENERATOR "Unix Makefiles")

# Include the machine-specific info
INCLUDE(${SITE_SCRIPT})

# Make sure the relevant variables have been set 
CHECK_SITE_VAR(CTEST_CMAKE_GENERATOR)
CHECK_SITE_VAR(CTEST_BUILD_NAME)
CHECK_SITE_VAR(CTEST_SITE)
CHECK_SITE_VAR(GIT_UID)
CHECK_SITE_VAR(GIT_BINARY)
CHECK_SITE_VAR(ROOT)

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
IF(${IN_MODEL} MATCHES "Nightly")
  CTEST_EMPTY_BINARY_DIRECTORY(${CTEST_BINARY_DIRECTORY})
ENDIF(${IN_MODEL} MATCHES "Nightly")

# Set the GIT path
IF(${IN_PRODUCT} MATCHES "itksnap")
  SET(GIT_URL "ssh://${GIT_UID}@itk-snap.git.sourceforge.net/gitroot/itk-snap/itksnap")
ELSE(${IN_PRODUCT} MATCHES "itksnap")
  MESSAGE(FATAL_ERROR "Unknown product ${IN_PRODUCT}")
ENDIF(${IN_PRODUCT} MATCHES "itksnap")

# Configure for GIT
set(CTEST_UPDATE_TYPE "git")
set(CTEST_UPDATE_COMMAND ${GIT_BINARY})

if(NOT EXISTS ${CTEST_SOURCE_DIRECTORY})
  file(MAKE_DIRECTORY ${CTEST_SOURCE_DIRECTORY})
  set(CTEST_CHECKOUT_COMMAND "${GIT_BINARY} clone -b ${IN_BRANCH} ${GIT_URL}")
endif(NOT EXISTS ${CTEST_SOURCE_DIRECTORY})

# Write the initial config file
file(WRITE ${CTEST_BINARY_DIRECTORY}/CMakeCache.txt ${INIT_CACHE})

MESSAGE(WARNING "Initial Cache ${INIT_CACHE}")
ctest_start(${IN_MODEL})
ctest_update()
ctest_configure()
ctest_build()
ctest_submit()

# For nightly builds that are uploaders
if(DEFINED DO_UPLOAD)
  ctest_build(TARGET package APPEND)
  ctest_build(TARGET upload_nightly APPEND)
endif(DEFINED DO_UPLOAD)

