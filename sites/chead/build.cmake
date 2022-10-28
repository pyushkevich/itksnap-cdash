#############################################
# Site-Specific Build Configuration Script  #
#############################################
#
# This script should be edited for each new site where
# we want to build ITK-SNAP and related tools. The
# general structure of this script should be followed on
# all sites, but some additonal variables (e.g., CTEST_ENVIRONMENT)
# may need to be set on some platforms and configurations

# ICC and GCC directories

# This is an upload site
SET(DO_UPLOAD TRUE)

# Skip debug builds if continuous (to save on space/time)
IF(MODEL STREQUAL "Continuous")
  SETCOND(SKIP_BUILD CONFIG ".*dbg.*")
  SETCOND(SKIP_BUILD CONFIG ".*osmesa.*")
ENDIF()

# Set build flags
SETCOND(CXXFLAGS "-std=c++11 -fpermissive" CONFIG "gcc64.*")

# For GCC use devtools2
IF(GCC_MAX MATCHES "7.*")
  SET(GCCDIR "/usr")
  CACHE_ADD("CMAKE_CXX_COMPILER:FILEPATH=${GCCDIR}/bin/g++-7" CONFIG "gcc.*")
  CACHE_ADD("CMAKE_C_COMPILER:FILEPATH=${GCCDIR}/bin/gcc-7" CONFIG "gcc.*")
ELSE()
  SET(GCCDIR "/usr")
  CACHE_ADD("CMAKE_CXX_COMPILER:FILEPATH=${GCCDIR}/bin/c++" CONFIG "gcc.*")
  CACHE_ADD("CMAKE_C_COMPILER:FILEPATH=${GCCDIR}/bin/gcc" CONFIG "gcc.*")
ENDIF()

# Allow parallel builds
ENV_ADD(MAKEFLAGS "-j 60")

# Add cache entries
CACHE_ADD("MAKECOMMAND:STRING=/usr/bin/make -i -j 32")
CACHE_ADD("CMAKE_MAKE_PROGRAM:FILEPATH=/usr/bin/make")
CACHE_ADD("CMAKE_BUILD_TYPE:STRING=Release" CONFIG ".*rel")
CACHE_ADD("CMAKE_BUILD_TYPE:STRING=Debug" CONFIG ".*dbg")
CACHE_ADD("CMAKE_CXX_FLAGS:STRING=${CXXFLAGS}")

# Tell C3D that the GUI should be built
CACHE_ADD("BUILD_GUI:BOOLEAN=ON" PRODUCT "c3d")

# For VTK we enable python because it is useful to have on the cluster
CACHE_ADD("VTK_WRAP_PYTHON:BOOL=OFF" PRODUCT "vtk")

# For VTK, set osmesa path
IF(${CONFIG_EXT} MATCHES ".*osmesa.*")
  SET(MESADIR "/data/hippogang/build/mesa-21.3/install")
  SET(MESALIBDIR "${MESADIR}/lib/x86_64-linux-gnu")

  # Mesa needs to be added to LD_LIBRARY_PATH so that packaging includes the shared libs
  ENV_ADD(LD_LIBRARY_PATH "${MESALIBDIR}:$ENV{LD_LIBRARY_PATH}")

  # Add cache entries for VTk
  CACHE_ADD("OSMESA_LIBRARY:FILEPATH=${MESALIBDIR}/libOSMesa.so" PRODUCT "vtk")
  CACHE_ADD("OSMESA_INCLUDE_DIR:PATH=${MESADIR}/include" PRODUCT "vtk")
  CACHE_ADD("OPENGL_INCLUDE_DIR:PATH=${MESADIR}/include" PRODUCT "vtk")
ENDIF()

# We need this because this is a cross-compilation
CACHE_ADD("CPACK_SYSTEM_NAME:STRING=Linux-i686" CONFIG "gcc32.*")
CACHE_ADD("CPACK_SYSTEM_NAME:STRING=Linux-gcc64" CONFIG "gcc64.*")
CACHE_ADD("CPACK_SYSTEM_NAME:STRING=Linux-icc64" CONFIG "icc64.*")

# Cm-rep related external libraries
CACHE_ADD("USE_TETGEN:BOOL=ON" PRODUCT "cmrep")
CACHE_ADD("USE_IPOPT:BOOL=ON" PRODUCT "cmrep")
CACHE_ADD("USE_NLOPT:BOOL=ON" PRODUCT "cmrep")
CACHE_ADD("USE_MUMPS:BOOL=ON" PRODUCT "cmrep")
CACHE_ADD("USE_EIGEN:BOOL=ON" PRODUCT "cmrep")
CACHE_ADD("USE_HSL:BOOL=ON" PRODUCT "cmrep")
CACHE_ADD("IPOPT_INCLUDE_DIR:PATH=/mnt/build/pauly/ipopt/install_gcc64_shareable/include/coin" PRODUCT "cmrep")
CACHE_ADD("IPOPT_LIBRARY:FILEPATH=/mnt/build/pauly/ipopt/install_gcc64_shareable/lib/libipopt.so" PRODUCT "cmrep")
CACHE_ADD("IPOPT_BLAS_LIB:FILEPATH=/usr/lib64/libblas.so.3" PRODUCT "cmrep")
CACHE_ADD("IPOPT_LAPACK_LIB:FILEPATH=/usr/lib64/liblapack.so.3" PRODUCT "cmrep")
CACHE_ADD("IPOPT_METIS_LIBRARY:FILEPATH=/mnt/build/pauly/ipopt/install_gcc64_shareable/lib/libcoinmetis.so" PRODUCT "cmrep")
CACHE_ADD("IPOPT_MUMPS_LIBRARY:FILEPATH=/mnt/build/pauly/ipopt/install_gcc64_shareable/lib/libcoinmumps.so" PRODUCT "cmrep")
CACHE_ADD("IPOPT_GFORTRAN_LIB:FILEPATH=/usr/lib64/libgfortran.so.3" PRODUCT "cmrep")
CACHE_ADD("IPOPT_HSL_LIBRARY:FILEPATH=/mnt/build/pauly/ipopt/install_gcc64_shareable/lib/libcoinhsl.so" PRODUCT "cmrep")
CACHE_ADD("NLOPT_INCLUDE_DIRS:PATH=/mnt/build/pauly/nlopt/nlopt-install/include" PRODUCT "cmrep")
CACHE_ADD("NLOPT_LIBRARIES:FILEPATH=/mnt/build/pauly/nlopt/nlopt-install/lib64/libnlopt.so" PRODUCT "cmrep")
CACHE_ADD("Eigen3_DIR:PATH=/mnt/build/pauly/Eigen/install-3.4.0/share/eigen3/cmake" PRODUCT "cmrep")
CACHE_ADD("TETGEN_INCLUDE_DIR:PATH=/mnt/build/pauly/tetgen/tetgen1.5.1" PRODUCT "cmrep")
CACHE_ADD("TETGEN_LIBRARY:FILEPATH=/mnt/build/pauly/tetgen/tetgen1.5.1/libtet.a" PRODUCT "cmrep")

# Add product-specific cache entries
IF(NEED_QT6)
  SETCOND(QT6DIR "/data/hippogang/build/Qt/6.2.2/gcc_64")
  CACHE_ADD("CMAKE_PREFIX_PATH:FILEPATH=${QT6DIR}/lib/cmake")

  # Miniconda clashes with CMAKE_PREFIX_PATH unfortunately
  CACHE_ADD("Qt6Widgets_DIR:PATH=${QT6DIR}/lib/cmake/Qt6Widgets")
  CACHE_ADD("Qt6Gui_DIR:PATH=${QT6DIR}/lib/cmake/Qt6Gui")
  CACHE_ADD("Qt6Sql_DIR:PATH=${QT6DIR}/lib/cmake/Qt6Sql")
  CACHE_ADD("Qt6Core_DIR:PATH=${QT6DIR}/lib/cmake/Qt6Core")
  ENV_ADD(LD_LIBRARY_PATH "${QT6DIR}/lib:$ENV{LD_LIBRARY_PATH}")
ENDIF()
