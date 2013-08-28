#############################################
# Site-Specific Build Configuration Script  #
#############################################
#
# This script should be edited for each new site where
# we want to build ITK-SNAP and related tools. The
# general structure of this script should be followed on
# all sites, but some additonal variables (e.g., CTEST_ENVIRONMENT)
# may need to be set on some platforms and configurations

# REQUIRED: Root directory : where is the build taking place
SET(ROOT "/mnt/build/pauly/buildbot")

# REQUIRED: define the descriptive site name and build name
set(CTEST_SITE "picslbuild")
set(CTEST_BUILD_NAME "CentOS-5.3-${IN_CONFIG}")

# REQUIRED: Where GIT is and who is the user with SSH capability
SET(GIT_BINARY /usr/local/bin/git)
SET(GIT_UID pyushkevich)

# Library directory: path where all the libraries are build (this is only used internally)
SET(TKDIR "/mnt/build/pauly")

# Depending on the configuration, set the library paths for this machine
# as well as some other settings
IF(${IN_CONFIG} MATCHES gcc64rel)

  SET(FLTK13 "${TKDIR}/fltk13/install_gcc64/lib/libfltk.a")
  SET(CFLAGS "-fno-strict-aliasing")
  SET(DO_UPLOAD TRUE)
  SET(QTDIR ${TKDIR}/Qt/qt-4.8.2)

ELSEIF(${IN_CONFIG} MATCHES icc64rel)
  
  SET(FLTK13 "${TKDIR}/fltk13/install_icc64/lib/libfltk.a")
  SET(CFLAGS "-wd1268 -wd1224 -wd858")
  SET(QTDIR ${TKDIR}/Qt/qt-4.8.2)

  ENV_ADD(CC "/opt/intel/cce/10.1.018/bin/icc")
  ENV_ADD(CXX "/opt/intel/cce/10.1.018/bin/icpc")
  ENV_ADD(LD_LIBRARY_PATH "/opt/intel/cce/10.1.018/lib")

ELSEIF(${IN_CONFIG} MATCHES gcc32rel)

  SET(FLTK13 "${TKDIR}/fltk13/install_gcc32/lib/libfltk.a")
  SET(CFLAGS "-m32 -fno-strict-aliasing")
  SET(QTDIR ${TKDIR}/Qt/qt-4.8.2-gcc32)

  SET(DO_UPLOAD TRUE)

ELSE(${IN_CONFIG} MATCHES gcc64rel)
  
  MESSAGE(FATAL_ERROR "Unknown configuration ${IN_CONFIG}")

ENDIF(${IN_CONFIG} MATCHES gcc64rel)

# Add cache entries
CACHE_ADD("MAKECOMMAND:STRING=/usr/bin/make -i -j 6")
CACHE_ADD("CMAKE_MAKE_PROGRAM:FILEPATH=/usr/bin/make")
CACHE_ADD("CMAKE_BUILD_TYPE:STRING=Release")
CACHE_ADD("CMAKE_C_FLAGS:STRING=${CFLAGS}")
CACHE_ADD("CMAKE_CXX_FLAGS:STRING=${CFLAGS}")
CACHE_ADD("ITK_DIR:PATH=${TKDIR}/itk42/${IN_CONFIG}")
CACHE_ADD("VTK_DIR:PATH=${TKDIR}/vtk580/${IN_CONFIG}" BRANCH "qtsnap.*")
CACHE_ADD("VTK_DIR:PATH=${TKDIR}/vtk561/${IN_CONFIG}" BRANCH "master")
CACHE_ADD("QT_QMAKE_EXECUTABLE:FILEPATH=${QTDIR}/bin/qmake")
CACHE_ADD("FLTK_BASE_LIBRARY:FILEPATH=${FLTK13}" PRODUCT "itksnap" BRANCH "master")

# Tell C3D that the GUI should be built
CACHE_ADD("BUILD_GUI:BOOLEAN=ON" PRODUCT "c3d")

# We need this because this is a cross-compilation
CACHE_ADD("CPACK_SYSTEM_NAME:STRING=Linux-i686" CONFIG "gcc32.*")

#CACHE_ADD("SNAP_USE_FLTK_PNG:BOOL=ON" BRANCH "master")
#CACHE_ADD("SNAP_USE_FLTK_JPEG:BOOL=ON" BRANCH "master")
