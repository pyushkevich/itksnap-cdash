# In order to retrieve a tag, we must string together two git commands, which requires calling the system shell
IF(UNIX)
  SET(PRODUCT_CHECKOUT_COMMAND 
    "sh -c \"${GIT_BINARY} clone http://itk.org/ITK.git ${IN_PRODUCT} && cd ${IN_PRODUCT} && ${GIT_BINARY} checkout ${IN_BRANCH}\"")
ELSEIF(WIN32)
  SET(PRODUCT_CHECKOUT_COMMAND 
    "cmd.exe /c \"${GIT_BINARY} clone http://itk.org/ITK.git ${IN_PRODUCT} && cd ${IN_PRODUCT} && ${GIT_BINARY} checkout ${IN_BRANCH}\"")
ENDIF(UNIX)

SET(PRODUCT_EXTERNAL ON)

CACHE_ADD("BUILD_TESTING:BOOL=FALSE")
CACHE_ADD("BUILD_EXAMPLES:BOOL=FALSE")

