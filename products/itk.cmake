# In order to retrieve a tag, we must string together two git commands, which requires calling the system shell
IF(UNIX)
  SET(PRODUCT_CHECKOUT_COMMAND 
    "sh -c \"${GIT_BINARY} clone https://github.com/InsightSoftwareConsortium/ITK.git ${IN_PRODUCT} && cd ${IN_PRODUCT} && ${GIT_BINARY} checkout ${IN_BRANCH}\"")
ELSEIF(WIN32)
  SET(PRODUCT_CHECKOUT_COMMAND 
      "\"${GIT_BINARY}\" clone -b ${IN_BRANCH} https://github.com/InsightSoftwareConsortium/ITK.git ${IN_PRODUCT}")
ENDIF(UNIX)

SET(PRODUCT_EXTERNAL ON)

CACHE_ADD("BUILD_TESTING:BOOL=FALSE")
CACHE_ADD("BUILD_EXAMPLES:BOOL=FALSE")
CACHE_ADD("Module_MorphologicalContourInterpolation:BOOL=TRUE" BRANCH "5.*")

# For 64 bit windows, make offsets be 64 bit type
IF(WIN32)
  IF(${CONFIG_BASE} MATCHES ".*64.*")
    CACHE_ADD("ITK_USE_64BITS_IDS:BOOL=TRUE")
  ENDIF(${CONFIG_BASE} MATCHES ".*64.*")
ENDIF(WIN32)

# Skip special qt4 builds
MESSAGE(STATUS "CONFIG_EXT=${CONFIG_EXT}")
IF((${CONFIG_EXT} MATCHES ".*qt4.*") OR (${CONFIG_EXT} MATCHES ".*osmesa.*"))
  SET(SKIP_BUILD ON)
ENDIF()

# Set max/min GCC version
IF(${IN_BRANCH} MATCHES "4.*")
  SET(GCC_MAX "7")
ENDIF()

