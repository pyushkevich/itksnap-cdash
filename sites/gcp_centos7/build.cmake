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
SET(GCCDIR "/opt/rh/devtoolset-7/root/usr/")

# This is an upload site
SET(DO_UPLOAD TRUE)

# For GCC use devtools7
CACHE_ADD("CMAKE_CXX_COMPILER:FILEPATH=${GCCDIR}/bin/c++")
CACHE_ADD("CMAKE_C_COMPILER:FILEPATH=${GCCDIR}/bin/gcc")

# Allow parallel builds
ENV_ADD(MAKEFLAGS "-j 32")

# Add cache entries
CACHE_ADD("MAKECOMMAND:STRING=/usr/bin/make -i -j 32")
CACHE_ADD("CMAKE_MAKE_PROGRAM:FILEPATH=/usr/bin/make")
CACHE_ADD("CMAKE_BUILD_TYPE:STRING=Release" CONFIG ".*rel")
CACHE_ADD("CMAKE_BUILD_TYPE:STRING=Debug" CONFIG ".*dbg")

# Tell C3D that the GUI should be built
CACHE_ADD("BUILD_GUI:BOOLEAN=ON" PRODUCT "c3d" BRANCH "master")
CACHE_ADD("BUILD_GUI:BOOLEAN=OFF" PRODUCT "c3d" BRANCH "itk5")

# For VTK we enable python because it is useful to have on the cluster
CACHE_ADD("VTK_WRAP_PYTHON:BOOL=OFF" PRODUCT "vtk")

# We need this because this is a cross-compilation
CACHE_ADD("CPACK_SYSTEM_NAME:STRING=Linux-gcc64")

# Cm-rep related external libraries
CACHE_ADD("USE_TETGEN:BOOL=ON" PRODUCT "cmrep")
CACHE_ADD("USE_IPOPT:BOOL=ON" PRODUCT "cmrep")
CACHE_ADD("USE_NLOPT:BOOL=ON" PRODUCT "cmrep")
CACHE_ADD("USE_MUMPS:BOOL=ON" PRODUCT "cmrep")
CACHE_ADD("USE_EIGEN:BOOL=ON" PRODUCT "cmrep")
CACHE_ADD("IPOPT_INCLUDE_DIR:PATH=/home/pyushkevich/tk/ipopt/include/coin-or" PRODUCT "cmrep")
CACHE_ADD("IPOPT_LIBRARY:FILEPATH=/home/pyushkevich/tk/ipopt/lib/libipopt.so.3" PRODUCT "cmrep")
CACHE_ADD("IPOPT_METIS_LIBRARY:FILEPATH=/usr/lib64/libmetis.so" PRODUCT "cmrep")
CACHE_ADD("IPOPT_GFORTRAN_LIB:FILEPATH=/usr/lib64/libgfortran.so.3" PRODUCT "cmrep")
CACHE_ADD("NLOPT_INCLUDE_DIRS:PATH=/home/pyushkevich/tk/nlopt/install/include" PRODUCT "cmrep")
CACHE_ADD("NLOPT_LIBRARIES:FILEPATH=/home/pyushkevich/tk/nlopt/install/lib64/libnlopt.a" PRODUCT "cmrep")
CACHE_ADD("Eigen3_DIR:PATH=/home/pyushkevich/tk/eigen/install/share/eigen3/cmake" PRODUCT "cmrep")

# Related to SCP
CACHE_ADD("SCP_ARGUMENTS:STRING=")

# Add product-specific cache entries
IF(NEED_QT4)
  SET(SKIP_BUILD ON)
ELSEIF(NEED_QT56)
  SETCOND(QT5DIR "/home/pyushkevich/tk/Qt2021/5.15.2/gcc_64")
  CACHE_ADD("CMAKE_PREFIX_PATH:FILEPATH=${QT5DIR}/lib/cmake")
  ENV_ADD(LD_LIBRARY_PATH "${QT5DIR}/lib:$ENV{LD_LIBRARY_PATH}")
ELSEIF(NEED_QT515)
  SETCOND(QT5DIR "/home/pyushkevich/tk/Qt2021/5.15.2/gcc_64")
  CACHE_ADD("CMAKE_PREFIX_PATH:FILEPATH=${QT5DIR}/lib/cmake")
  ENV_ADD(LD_LIBRARY_PATH "${QT5DIR}/lib:$ENV{LD_LIBRARY_PATH}")
ELSEIF(NEED_QT5)
  SET(SKIP_BUILD ON)
ENDIF()
