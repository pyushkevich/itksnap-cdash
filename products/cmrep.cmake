SET(PRODUCT_CHECKOUT_COMMAND 
  "${GIT_BINARY} clone -b ${IN_BRANCH} https://github.com/pyushkevich/cmrep.git ${IN_PRODUCT}")

# SET UP PRODUCT-SPECIFIC CACHE ENTRIES
CACHE_ADD("ITK_DIR:PATH=${ROOT}/Nightly/itk/v5.1.2/${IN_CONFIG}" BRANCH "master")
CACHE_ADD("VTK_DIR:PATH=${ROOT}/Nightly/vtk/v8.2.0/${IN_CONFIG}" BRANCH "master")
CACHE_ADD("ITK_DIR:PATH=${ROOT}/Nightly/itk/v5.2.1/${IN_CONFIG}" BRANCH "vtk9")
CACHE_ADD("VTK_DIR:PATH=${ROOT}/Nightly/vtk/v9.1.0/${IN_CONFIG}" BRANCH "vtk9")

# Skip special config extensions
IF((${CONFIG_EXT} MATCHES ".*qt4.*") OR (${CONFIG_EXT} MATCHES ".*osmesa.*"))
  SET(SKIP_BUILD ON)
ENDIF()
