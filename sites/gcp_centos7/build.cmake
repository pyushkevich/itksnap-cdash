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
SET(TKDIR "/mnt/build/pyushkevich")

# ICC and GCC directories
# SET(GCCDIR "/opt/rh/devtoolset-2/root/usr/")

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
ENV_ADD(MAKEFLAGS "-j 32")

# Add cache entries
CACHE_ADD("MAKECOMMAND:STRING=/usr/bin/make -i -j 32")
CACHE_ADD("CMAKE_MAKE_PROGRAM:FILEPATH=/usr/bin/make")
CACHE_ADD("CMAKE_BUILD_TYPE:STRING=Release" CONFIG ".*rel")
CACHE_ADD("CMAKE_BUILD_TYPE:STRING=Debug" CONFIG ".*dbg")
CACHE_ADD("CMAKE_C_FLAGS:STRING=${CFLAGS}")
CACHE_ADD("CMAKE_CXX_FLAGS:STRING=${CFLAGS}")

# Tell C3D that the GUI should be built
CACHE_ADD("BUILD_GUI:BOOLEAN=ON" PRODUCT "c3d")

# For VTK we enable python because it is useful to have on the cluster
CACHE_ADD("VTK_WRAP_PYTHON:BOOL=OFF" PRODUCT "vtk")

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
  SETCOND(QT4DIR "/mnt/build/pyushkevich/Qt48" CONFIG ".*64rel")
  SETCOND(QT4DIR "/mnt/build/pyushkevich/Qt48_Debug" CONFIG ".*64dbg")
  SETCOND(SKIP_BUILD ON CONFIG ".*32.*")
  CACHE_ADD("QT_QMAKE_EXECUTABLE:FILEPATH=${QT4DIR}/bin/qmake")
ELSEIF(NEED_QT56)
  SETCOND(QT5DIR "/mnt/build/pyushkevich/Qt56" CONFIG ".*64rel*")
  SETCOND(QT5DIR "/mnt/build/pyushkevich/Qt56_Debug" CONFIG ".*64dbg*")
  SETCOND(SKIP_BUILD ON CONFIG ".*32.*")
  CACHE_ADD("CMAKE_PREFIX_PATH:FILEPATH=${QT5DIR}/lib/cmake")
  ENV_ADD(LD_LIBRARY_PATH "${QT5DIR}/lib:$ENV{LD_LIBRARY_PATH}")
ELSEIF(NEED_QT5)
  SET(SKIP_BUILD ON)
ENDIF()
