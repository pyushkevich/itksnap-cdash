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
SET(DO_UPLOAD OFF)

# Mac Framework directory
SET(MINVER 10.12)
SET(FWDIR "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk")

# Depending on the configuration, set the library paths for this machine
# as well as some other settings
SETCOND(ARCH i386 CONFIG xc32rel)
SETCOND(ARCH x86_64 CONFIG xc64rel)

ENV_ADD(MAKEFLAGS "-j 20")

# Add general cache entries
CACHE_ADD("MAKECOMMAND:STRING=/usr/bin/make -i -j 8")
CACHE_ADD("CMAKE_MAKE_PROGRAM:FILEPATH=/usr/bin/make")
CACHE_ADD("CMAKE_BUILD_TYPE:STRING=Release" CONFIG ".*rel")
CACHE_ADD("CMAKE_BUILD_TYPE:STRING=Debug" CONFIG ".*dbg")
CACHE_ADD("CMAKE_C_FLAGS:STRING=-mmacosx-version-min=${MINVER} -Wno-deprecated -Wno-implicit-function-declaration")
CACHE_ADD("CMAKE_CXX_FLAGS:STRING=-mmacosx-version-min=${MINVER} -Wno-deprecated -Wno-implicit-function-declaration --std=c++11")
CACHE_ADD("ARCH:STRING=${ARCH}")
CACHE_ADD("CMAKE_OSX_ARCHITECTURES:STRING=${ARCH}")
CACHE_ADD("BUILD_GUI:BOOL=ON" PRODUCT "c3d")

# Entries for CMREP
CACHE_ADD("USE_EIGEN:BOOL=ON" PRODUCT "cmrep")
CACHE_ADD("USE_LAPACK:BOOL=ON" PRODUCT "cmrep")
CACHE_ADD("Eigen3_DIR:PATH=/Users/pauly/tk/eigen/install/share/eigen3/cmake" PRODUCT "cmrep")
CACHE_ADD("LAPACK_LIB:FILEPATH=/usr/lib/liblapack.dylib" PRODUCT "cmrep")
CACHE_ADD("BLAS_LIB:FILEPATH=/usr/lib/libblas.dylib" PRODUCT "cmrep")
CACHE_ADD("G2C_LIB:FILEPATH=/usr/local/Cellar/gcc/9.3.0/lib/gcc/9/libgfortran.a" PRODUCT "cmrep")

# Library directory: path where all the libraries are build (this is only used internally)
SET(TKDIR "/Users/pauly/tk")

# Add product-specific cache entries
IF(NEED_FLTK)
  SET(FLTK13 "${TKDIR}/fltk/install/lib/libfltk.a")
  CACHE_ADD("FLTK_BASE_LIBRARY:FILEPATH=${FLTK13}")
  CACHE_ADD("SNAP_USE_FLTK_PNG:BOOL=ON")
  CACHE_ADD("SNAP_USE_FLTK_JPEG:BOOL=ON")
ENDIF(NEED_FLTK)

IF(NEED_QT4)
  CACHE_ADD("QT_QMAKE_EXECUTABLE:FILEPATH=${TKDIR}/qt48/install/bin/qmake")
ENDIF(NEED_QT4)

IF(NEED_QT5)
  CACHE_ADD("CMAKE_PREFIX_PATH:STRING=${TKDIR}/Qt/5.3/clang_64/lib/cmake")
ENDIF(NEED_QT5)

IF(NEED_QT54)
  CACHE_ADD("CMAKE_PREFIX_PATH:STRING=/Users/pauly/Qt/5.4/clang_64/lib/cmake")
ENDIF(NEED_QT54)
  
IF(NEED_QT56)
  CACHE_ADD("CMAKE_PREFIX_PATH:STRING=/Users/pauly/Qt/5.12.6/clang_64/lib/cmake")
ENDIF(NEED_QT56)
  
