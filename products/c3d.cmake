SET(PRODUCT_CHECKOUT_COMMAND 
  "${GIT_BINARY} clone -b ${IN_BRANCH} https://github.com/pyushkevich/c3d.git ${IN_PRODUCT}")

# SET UP PRODUCT-SPECIFIC CACHE ENTRIES
CACHE_ADD("ITK_DIR:PATH=${ROOT}/Nightly/itk/v5.2.1/${IN_CONFIG}")

# SPECIFY which products we need
SETCOND(NEED_QT6 ON BRANCH "master")

# Skip special config extensions
IF((${CONFIG_EXT} MATCHES ".*qt4.*") OR (${CONFIG_EXT} MATCHES ".*osmesa.*"))
  SET(SKIP_BUILD ON)
ENDIF()
