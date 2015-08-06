# In order to retrieve a tag, we must string together two git commands, which requires calling the system shell
IF(UNIX)
  SET(PRODUCT_CHECKOUT_COMMAND 
    "sh -c \"${GIT_BINARY} clone https://gitlab.kitware.com/vtk/vtk.git ${IN_PRODUCT} && cd ${IN_PRODUCT} && ${GIT_BINARY} checkout ${IN_BRANCH}\"")
ELSEIF(WIN32)
  SET(PRODUCT_CHECKOUT_COMMAND 
      "\"${GIT_BINARY}\" clone -b ${IN_BRANCH} https://gitlab.kitware.com/vtk/vtk.git ${IN_PRODUCT}")
ENDIF(UNIX)

SET(PRODUCT_EXTERNAL ON)

CACHE_ADD("BUILD_TESTING:BOOL=FALSE")
CACHE_ADD("BUILD_EXAMPLES:BOOL=FALSE")
CACHE_ADD("BUILD_SHARED_LIBS:BOOL=FALSE")
CACHE_ADD("VTK_REQUIRED_OBJCXX_FLAGS:STRING=")
