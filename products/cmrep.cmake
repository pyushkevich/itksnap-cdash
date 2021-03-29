SET(PRODUCT_CHECKOUT_COMMAND 
  "${GIT_BINARY} clone -b ${IN_BRANCH} https://github.com/pyushkevich/cmrep.git ${IN_PRODUCT}")

# SET UP PRODUCT-SPECIFIC CACHE ENTRIES
CACHE_ADD("ITK_DIR:PATH=${ROOT}/Nightly/itk/v4.13.2/${IN_CONFIG}" BRANCH "master")
CACHE_ADD("VTK_DIR:PATH=${ROOT}/Nightly/vtk/v6.3.0/${IN_CONFIG}" BRANCH "master")
