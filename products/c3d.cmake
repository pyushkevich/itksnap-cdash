SET(PRODUCT_CHECKOUT_COMMAND 
  "${GIT_BINARY} clone -b ${IN_BRANCH} ssh://${GIT_UID}@git.code.sf.net/p/c3d/git ${IN_PRODUCT}")

# SET UP PRODUCT-SPECIFIC CACHE ENTRIES
CACHE_ADD("ITK_DIR:PATH=${ROOT}/Nightly/itk/v4.5.2/${IN_CONFIG}")

# SPECIFY which products we need
SETCOND(NEED_QT54 ON BRANCH "master")

# Skip special qt4 builds
IF(${CONFIG_EXT} MATCHES ".*qt4.*")
  SET(SKIP_BUILD ON)
ENDIF(${CONFIG_EXT} MATCHES ".*qt4.*")
