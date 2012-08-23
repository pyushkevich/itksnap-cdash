# Include the machine-specific info
INCLUDE(${CTEST_SCRIPT_DIRECTORY}/sites/${CTEST_SCRIPT_ARG}.cmake)

# Directories for this build
SET (CTEST_SOURCE_DIRECTORY "${ROOT}/experimental/itksnap")
SET (CTEST_BINARY_DIRECTORY "${ROOT}/experimental/${CONFIG}")

# Nightly build is always done from scratch
SET(CTEST_START_WITH_EMPTY_BINARY_DIRECTORY FALSE)
SET(CTEST_BACKUP_AND_RESTORE FALSE)

# Commands executed by ctest
SET (CTEST_COMMAND 
  "${CTEST_CTEST_COMMAND} -M Experimental -T Start -T Update -T Configure -T Build -T Test -T Submit"
  "${CTEST_MAKE_COMMAND} package")

# Include the upload step
IF(NOT SKIP_UPLOAD)
  SET (CTEST_COMMAND ${CTEST_COMMAND} 
    "${CTEST_MAKE_COMMAND} upload_experimental")
ENDIF()
