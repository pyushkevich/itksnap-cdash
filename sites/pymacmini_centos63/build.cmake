#############################################
# Site-Specific Build Configuration Script  #
#############################################
#
# This script should be edited for each new site where
# we want to build ITK-SNAP and related tools. The
# general structure of this script should be followed on
# all sites, but some additonal variables (e.g., CTEST_ENVIRONMENT)
# may need to be set on some platforms and configurations

# Library directory: path where all the libraries are built (this is only used internally)
SET(TKDIR "/home/picsl/tk")

# This is an upload site
SET(DO_UPLOAD TRUE)

# Skip most products when .qt4 options used
IF(${CONFIG_EXT} MATCHES "qt4")
  SET(SKIP_BUILD ON)
  SETCOND(SKIP_BUILD OFF PRODUCT itksnap BRANCH master)
ENDIF(${CONFIG_EXT} MATCHES "qt4")

# Set build flags
SETCOND(CFLAGS "-fno-strict-aliasing -fPIC" CONFIG "gcc64.*")
SETCOND(CFLAGS "-m32 -fno-strict-aliasing -fPIC" CONFIG "gcc32.*")

# Allow parallel builds
ENV_ADD(MAKEFLAGS "-j 2")

# Add cache entries
CACHE_ADD("MAKECOMMAND:STRING=/usr/bin/make -i -j 2")
CACHE_ADD("CMAKE_MAKE_PROGRAM:FILEPATH=/usr/bin/make")
CACHE_ADD("CMAKE_BUILD_TYPE:STRING=Release")
CACHE_ADD("CMAKE_C_FLAGS:STRING=${CFLAGS}")
CACHE_ADD("CMAKE_CXX_FLAGS:STRING=${CFLAGS}")

# Tell C3D that the GUI should be built
CACHE_ADD("BUILD_GUI:BOOLEAN=ON" PRODUCT "c3d")

# We need this because this is a cross-compilation
CACHE_ADD("CPACK_SYSTEM_NAME:STRING=Linux-i686" CONFIG "gcc32.*")

# Add product-specific cache entries
IF(NEED_FLTK)
  SET(SKIP_BUILD ON)
ENDIF(NEED_FLTK)

IF(NEED_QT4)
  SETCOND(QT4DIR "/home/picsl/Qt48/install_gcc64" CONFIG "gcc64.*")
  SETCOND(SKIP_BUILD ON CONFIG "gcc32.*")
  CACHE_ADD("QT_QMAKE_EXECUTABLE:FILEPATH=${QT4DIR}/bin/qmake")
ENDIF(NEED_QT4)

IF(NEED_QT5)
  SETCOND(QT5DIR "/home/picsl/Qt_5.3/5.3/gcc_64" CONFIG "gcc64.*")
  SETCOND(QT5DIR "/home/picsl/Qt32/5.3/gcc" CONFIG "gcc32.*")
  CACHE_ADD("CMAKE_PREFIX_PATH:FILEPATH=${QT5DIR}/lib/cmake")
  ENV_ADD(LD_LIBRARY_PATH "${QT5DIR}/lib:$ENV{LD_LIBRARY_PATH}")
ENDIF(NEED_QT5)

IF(NEED_QT54)
  SETCOND(QT5DIR "/home/picsl/Qt/5.4/gcc_64" CONFIG "gcc64.*")
  SETCOND(SKIP_BUILD ON CONFIG "gcc32.*")
  CACHE_ADD("CMAKE_PREFIX_PATH:FILEPATH=${QT5DIR}/lib/cmake")
  ENV_ADD(LD_LIBRARY_PATH "${QT5DIR}/lib:$ENV{LD_LIBRARY_PATH}")
ENDIF(NEED_QT54)
