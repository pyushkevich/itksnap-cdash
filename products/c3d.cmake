SET(PRODUCT_CHECKOUT_COMMAND 
  "${GIT_BINARY} clone -b ${IN_BRANCH} https://github.com/pyushkevich/c3d.git ${IN_PRODUCT}")

# SET UP PRODUCT-SPECIFIC CACHE ENTRIES
CACHE_ADD("ITK_DIR:PATH=${ROOT}/Nightly/itk/v4.12.2/${IN_CONFIG}" BRANCH "master")
CACHE_ADD("ITK_DIR:PATH=${ROOT}/Nightly/itk/v5.1.2/${IN_CONFIG}" BRANCH "itk5")

# SPECIFY which products we need
SETCOND(NEED_QT56 ON BRANCH "master")

# Skip special qt4 builds
IF(${CONFIG_EXT} MATCHES ".*qt4.*")
  SET(SKIP_BUILD ON)
ENDIF(${CONFIG_EXT} MATCHES ".*qt4.*")
