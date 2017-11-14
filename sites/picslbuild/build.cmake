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

# ICC and GCC directories
SET(ICCDIR "/opt/intel/cce/10.1.018/")
SET(GCCDIR "/opt/rh/devtoolset-2/root/usr/")

# This is an upload site
SET(DO_UPLOAD TRUE)

# Set build flags
SETCOND(CFLAGS "-fno-strict-aliasing -fPIC" CONFIG "gcc64.*")
SETCOND(CFLAGS "-m32 -fno-strict-aliasing -fPIC" CONFIG "gcc32.*")
SETCOND(CFLAGS "-wd1224 -wd1268 -wd858" CONFIG icc64rel)

# For intel compiler
CACHE_ADD("CMAKE_CXX_COMPILER:FILEPATH=${ICCDIR}/bin/icpc" CONFIG icc64rel)
CACHE_ADD("CMAKE_C_COMPILER:FILEPATH=${ICCDIR}/bin/icc" CONFIG icc64rel)

# For GCC use devtools2
CACHE_ADD("CMAKE_CXX_COMPILER:FILEPATH=${GCCDIR}/bin/c++" CONFIG "gcc.*")
CACHE_ADD("CMAKE_C_COMPILER:FILEPATH=${GCCDIR}/bin/gcc" CONFIG "gcc.*")

# Allow parallel builds
ENV_ADD(MAKEFLAGS "-j 12")

# Add cache entries
CACHE_ADD("MAKECOMMAND:STRING=/usr/bin/make -i -j 12")
CACHE_ADD("CMAKE_MAKE_PROGRAM:FILEPATH=/usr/bin/make")
CACHE_ADD("CMAKE_BUILD_TYPE:STRING=Release" CONFIG ".*rel")
CACHE_ADD("CMAKE_BUILD_TYPE:STRING=Debug" CONFIG ".*dbg")
CACHE_ADD("CMAKE_C_FLAGS:STRING=${CFLAGS}")
CACHE_ADD("CMAKE_CXX_FLAGS:STRING=${CFLAGS}")

# Tell C3D that the GUI should be built
CACHE_ADD("BUILD_GUI:BOOLEAN=ON" PRODUCT "c3d")

# For VTK we enable python because it is useful to have on the cluster
CACHE_ADD("VTK_WRAP_PYTHON:BOOL=ON" PRODUCT "vtk")

# We need this because this is a cross-compilation
CACHE_ADD("CPACK_SYSTEM_NAME:STRING=Linux-i686" CONFIG "gcc32.*")
CACHE_ADD("CPACK_SYSTEM_NAME:STRING=Linux-gcc64" CONFIG "gcc64.*")
CACHE_ADD("CPACK_SYSTEM_NAME:STRING=Linux-icc64" CONFIG "icc64.*")

# Add product-specific cache entries
IF(NEED_FLTK)
  SETCOND(FLTKDIR "${TKDIR}/fltk13/install_gcc64" CONFIG ".*64.*")
  SETCOND(FLTKDIR "${TKDIR}/fltk13/install_gcc32" CONFIG ".*32.*")
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
