#############################################
# Site-Specific Build Configuration Script  #
#############################################
#
# This script should be edited for each new site where
# we want to build ITK-SNAP and related tools. The
# general structure of this script should be followed on
# all sites, but some additonal variables (e.g., CTEST_ENVIRONMENT)
# may need to be set on some platforms and configurations

# This site uploads all of its builds
SETCOND(DO_UPLOAD ON CONFIG ".*rel")

# Depending on the configuration, set the library paths for this machine
# as well as some other settings
SETCOND(ARCH "arm64" CONFIG "^xc64...$")
SETCOND(ARCH "x86_64" CONFIG "^xc64...-x86_64$")

# Build X86 for older MacOS not to annoy people
CACHE_ADD("CMAKE_OSX_DEPLOYMENT_TARGET:STRING=11.0" CONFIG "^xc64...-x86_64$")

# Skip older versions that won't compile on M1
SETCOND(SKIP_BUILD ON PRODUCT "itk" BRANCH "v4.*")
SETCOND(SKIP_BUILD ON PRODUCT "vtk" BRANCH "v6.*")

ENV_ADD(MAKEFLAGS "-j 32")

# Add general cache entries
CACHE_ADD("CMAKE_BUILD_TYPE:STRING=Release" CONFIG ".*rel")
CACHE_ADD("CMAKE_BUILD_TYPE:STRING=Debug" CONFIG ".*dbg")
CACHE_ADD("MAKECOMMAND:STRING=/usr/bin/make -i -j 32")
CACHE_ADD("CMAKE_MAKE_PROGRAM:FILEPATH=/usr/bin/make")
CACHE_ADD("ARCH:STRING=${ARCH}")
CACHE_ADD("CMAKE_OSX_ARCHITECTURES:STRING=${ARCH}")
CACHE_ADD("BUILD_GUI:BOOL=ON" PRODUCT "c3d")

CACHE_ADD("BUILD_SHARED_LIBS:BOOL=TRUE" PRODUCT "vtk" CONFIG "xc64dbg")
CACHE_ADD("BUILD_SHARED_LIBS:BOOL=TRUE" PRODUCT "itksnap" CONFIG "xc64dbg")

# Support for code signing
CACHE_ADD("SNAP_MACOSX_CODESIGN_CERT:STRING=Developer ID Application: Paul Yushkevich (5A636Q488D)")

# Library directory: path where all the libraries are build (this is only used internally)
SET(TKDIR "/Users/pauly/tk")

# Add product-specific cache entries
IF(NEED_QT6)
  CACHE_ADD("CMAKE_PREFIX_PATH:FILEPATH=/Users/pauly/Qt/6.2.2/macos/lib/cmake")
ENDIF()

# Set up for CMREP
CACHE_ADD("USE_EIGEN:BOOL=TRUE" PRODUCT "cmrep")
