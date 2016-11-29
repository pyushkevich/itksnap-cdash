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
SET(TKDIR "/mnt/build/pauly")

# This is an upload site
SET(DO_UPLOAD TRUE)

# Set build flags
SETCOND(CFLAGS "-fno-strict-aliasing -fPIC" CONFIG gcc64rel)
SETCOND(CFLAGS "-m32 -fno-strict-aliasing -fPIC" CONFIG gcc32rel)
SETCOND(CFLAGS "-wd1224 -wd1268 -wd858" CONFIG icc64rel)

# For intel compiler
CACHE_ADD("CMAKE_CXX_COMPILER:FILEPATH=/opt/intel/cce/10.1.018/bin/icpc" CONFIG icc64rel)
CACHE_ADD("CMAKE_C_COMPILER:FILEPATH=/opt/intel/cce/10.1.018/bin/icc" CONFIG icc64rel)

# Allow parallel builds
ENV_ADD(MAKEFLAGS "-j 12")

# Add cache entries
CACHE_ADD("MAKECOMMAND:STRING=/usr/bin/make -i -j 12")
CACHE_ADD("CMAKE_MAKE_PROGRAM:FILEPATH=/usr/bin/make")
CACHE_ADD("CMAKE_BUILD_TYPE:STRING=Release")
CACHE_ADD("CMAKE_C_FLAGS:STRING=${CFLAGS}")
CACHE_ADD("CMAKE_CXX_FLAGS:STRING=${CFLAGS}")

# Tell C3D that the GUI should be built
CACHE_ADD("BUILD_GUI:BOOLEAN=ON" PRODUCT "c3d")

# We need this because this is a cross-compilation
CACHE_ADD("CPACK_SYSTEM_NAME:STRING=Linux-i686" CONFIG "gcc32.*")
CACHE_ADD("CPACK_SYSTEM_NAME:STRING=Linux-icc64" CONFIG "icc64.*")

# Add product-specific cache entries
IF(NEED_FLTK)
  SETCOND(FLTKDIR "${TKDIR}/fltk13/install_gcc64" CONFIG "gcc64rel")
  SETCOND(FLTKDIR "${TKDIR}/fltk13/install_gcc32" CONFIG "gcc32rel")
  CACHE_ADD("FLTK_BASE_LIBRARY:FILEPATH=${FLTKDIR}/lib/libfltk.a")
ENDIF(NEED_FLTK)

IF(NEED_QT4)
  SETCOND(QT4DIR "/mnt/build/pauly/Qt/qt-4.8.2-gcc64" CONFIG gcc64rel)
  SETCOND(QT4DIR "/mnt/build/pauly/Qt/qt-4.8.2-gcc64" CONFIG icc64rel)
  SETCOND(QT4DIR "/mnt/build/pauly/Qt/qt-4.8.2-gcc32" CONFIG gcc32rel)
  CACHE_ADD("QT_QMAKE_EXECUTABLE:FILEPATH=${QT4DIR}/bin/qmake")
ENDIF(NEED_QT4)

IF(NEED_QT5)
  SET(SKIP_BUILD ON)
ENDIF(NEED_QT5)
