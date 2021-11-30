#############################################
# Site-Specific Build Configuration Script  #
#############################################
#
# This script should be edited for each new site where
# we want to build ITK-SNAP and related tools. The
# general structure of this script should be followed on
# all sites, but some additonal variables (e.g., CTEST_ENVIRONMENT)
# may need to be set on some platforms and configurations

# This is an upload site
SET(DO_UPLOAD FALSE)

# Skip all but most recent versions
IF(NOT SKIP_BUILD)
  SET(SKIP_BUILD ON)
  SETCOND(SKIP_BUILD OFF PRODUCT "itk" BRANCH "v5.1.2")
  SETCOND(SKIP_BUILD OFF PRODUCT "vtk" BRANCH "v8.2.0" CONFIG ".*osmesa.*")
  SETCOND(SKIP_BUILD OFF PRODUCT "itksnap" BRANCH "vtk_render" CONFIG ".*osmesa.*")
ENDIF()

# Set build flags
SETCOND(CFLAGS "-fno-strict-aliasing -fPIC -std=c++11" CONFIG "gcc64.*")

# Allow parallel builds
ENV_ADD(MAKEFLAGS "-j 4")

# Add cache entries
CACHE_ADD("MAKECOMMAND:STRING=/usr/bin/make -i -j 4")
CACHE_ADD("CMAKE_MAKE_PROGRAM:FILEPATH=/usr/bin/make")
CACHE_ADD("CMAKE_BUILD_TYPE:STRING=Release" CONFIG ".*rel.*")
CACHE_ADD("CMAKE_BUILD_TYPE:STRING=Debug" CONFIG ".*dbg.*")
CACHE_ADD("CMAKE_C_FLAGS:STRING=${CFLAGS}")
CACHE_ADD("CMAKE_CXX_FLAGS:STRING=${CFLAGS}")

# Tell C3D that the GUI should be built
CACHE_ADD("BUILD_GUI:BOOLEAN=ON" PRODUCT "c3d")

# For VTK, set osmesa path
IF(${CONFIG_EXT} MATCHES ".*osmesa.*")
  CACHE_ADD("OSMESA_LIBRARY:FILEPATH=/home/user/mesa-21.3/install/lib/x86_64-linux-gnu/libOSMesa.so" PRODUCT "vtk")
  CACHE_ADD("OSMESA_INCLUDE_DIR:PATH=/home/user/mesa-21.3/install/lib/x86_64-linux-gnu/include" PRODUCT "vtk")
  CACHE_ADD("OPENGL_INCLUDE_DIR:PATH=/home/user/mesa-21.3/install/lib/x86_64-linux-gnu/include" PRODUCT "vtk")
ENDIF()

# We need this because this is a cross-compilation
CACHE_ADD("CPACK_SYSTEM_NAME:STRING=Linux-gcc64" CONFIG "gcc64.*")

IF(NEED_QT515)
  SETCOND(QT5DIR "/opt/Qt/5.15.2/gcc_64")
  CACHE_ADD("CMAKE_PREFIX_PATH:FILEPATH=${QT5DIR}/lib/cmake")

  # Miniconda clashes with CMAKE_PREFIX_PATH unfortunately
  CACHE_ADD("Qt5Widgets_DIR:PATH=${QT5DIR}/lib/cmake/Qt5Widgets")
  CACHE_ADD("Qt5Gui_DIR:PATH=${QT5DIR}/lib/cmake/Qt5Gui")
  CACHE_ADD("Qt5Sql_DIR:PATH=${QT5DIR}/lib/cmake/Qt5Sql")
  CACHE_ADD("Qt5Core_DIR:PATH=${QT5DIR}/lib/cmake/Qt5Core")
  ENV_ADD(LD_LIBRARY_PATH "${QT5DIR}/lib:$ENV{LD_LIBRARY_PATH}")
ENDIF()
