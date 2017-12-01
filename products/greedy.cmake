SET(PRODUCT_CHECKOUT_COMMAND 
  "${GIT_BINARY} clone -b ${IN_BRANCH} https://github.com/pyushkevich/greedy.git ${IN_PRODUCT}")

# SET UP PRODUCT-SPECIFIC CACHE ENTRIES
CACHE_ADD("ITK_DIR:PATH=${ROOT}/Nightly/itk/v4.12.2/${IN_CONFIG}")

# Skip special qt4 builds
IF(${CONFIG_EXT} MATCHES ".*qt4.*")
  SET(SKIP_BUILD ON)
ENDIF(${CONFIG_EXT} MATCHES ".*qt4.*")
