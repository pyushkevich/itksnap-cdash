# In order to retrieve a tag, we must string together two git commands, which requires calling the system shell
IF(UNIX)
  SET(PRODUCT_CHECKOUT_COMMAND 
    "sh -c \"${GIT_BINARY} clone http://itk.org/ITK.git ${IN_PRODUCT} && cd ${IN_PRODUCT} && ${GIT_BINARY} checkout ${IN_BRANCH}\"")
ELSEIF(WIN32)
  SET(PRODUCT_CHECKOUT_COMMAND 
      "\"${GIT_BINARY}\" clone -b ${IN_BRANCH} http://itk.org/ITK.git ${IN_PRODUCT}")
ENDIF(UNIX)

SET(PRODUCT_EXTERNAL ON)

CACHE_ADD("BUILD_TESTING:BOOL=FALSE")
CACHE_ADD("BUILD_EXAMPLES:BOOL=FALSE")

# For 64 bit windows, make offsets be 64 bit type
IF(WIN32)
  IF(${CONFIG_BASE} MATCHES ".*64.*")
    CACHE_ADD("ITK_USE_64BITS_IDS:BOOL=TRUE")
  ENDIF(${CONFIG_BASE} MATCHES ".*64.*")
ENDIF(WIN32)

# Skip special qt4 builds
IF(${CONFIG_EXT} MATCHES ".*qt4.*")
  SET(SKIP_BUILD ON)
ENDIF(${CONFIG_EXT} MATCHES ".*qt4.*")
