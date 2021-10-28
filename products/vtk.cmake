# In order to retrieve a tag, we must string together two git commands, which requires calling the system shell
IF(UNIX)
  SET(PRODUCT_CHECKOUT_COMMAND 
    "sh -c \"${GIT_BINARY} clone https://github.com/Kitware/VTK.git ${IN_PRODUCT} && cd ${IN_PRODUCT} && ${GIT_BINARY} checkout ${IN_BRANCH}\"")
ELSEIF(WIN32)
  SET(PRODUCT_CHECKOUT_COMMAND 
      "\"${GIT_BINARY}\" clone -b ${IN_BRANCH} https://github.com/Kitware/VTK.git ${IN_PRODUCT}")
ENDIF(UNIX)

SET(PRODUCT_EXTERNAL ON)

CACHE_ADD("BUILD_TESTING:BOOL=FALSE")
CACHE_ADD("BUILD_EXAMPLES:BOOL=FALSE")
CACHE_ADD("BUILD_SHARED_LIBS:BOOL=FALSE")
CACHE_ADD("VTK_REQUIRED_OBJCXX_FLAGS:STRING=")
CACHE_ADD("VTK_Group_Qt:BOOL=TRUE" BRANCH "8.*")
SETCOND(NEED_QT515 ON BRANCH "8.*")

# Skip special qt4 builds
IF(${CONFIG_EXT} MATCHES ".*qt4.*")
  SET(SKIP_BUILD ON)
ENDIF(${CONFIG_EXT} MATCHES ".*qt4.*")
