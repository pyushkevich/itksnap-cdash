#############################################
# Site-Specific Build Configuration Script  #
#############################################
#
# This script should be edited for each new site where
# we want to build ITK-SNAP and related tools. The
# general structure of this script should be followed on
# all sites, but some additonal variables (e.g., CTEST_ENVIRONMENT)
# may need to be set on some platforms and configurations

# Root directory
SET(ROOT "/home/pauly/tk/buildbot")

# REQUIRED: define the descriptive site name and build name
set(CTEST_SITE "paulyimac_centos5_x86")
set(CTEST_BUILD_NAME "CentOS-5.2-${IN_CONFIG}")

# REQUIRED: Where GIT is and who is the user with SSH capability
SET(GIT_BINARY /usr/bin/git)
SET(GIT_UID pyushkevich)

# Library directory: path where all the libraries are build (this is only used internally)
SET(TKDIR "/home/pauly/tk")

# Add cache entries
CACHE_ADD("MAKECOMMAND:STRING=/usr/bin/make -i")
CACHE_ADD("CMAKE_MAKE_PROGRAM:FILEPATH=/usr/bin/make")
CACHE_ADD("CMAKE_BUILD_TYPE:STRING=Release")
CACHE_ADD("ITK_DIR:PATH=${TKDIR}/itk420/${IN_CONFIG}")
CACHE_ADD("VTK_DIR:PATH=${TKDIR}/vtk561/${IN_CONFIG}" BRANCH "master")
CACHE_ADD("QT_QMAKE_EXECUTABLE:FILEPATH=${TKDIR}/Qt/qt-4.8.2/bin/qmake" BRANCH "qtsnap.*")
CACHE_ADD("FLTK_BASE_LIBRARY:FILEPATH=${TKDIR}/fltk13/install/lib/libfltk.a" BRANCH "master")
CACHE_ADD("SNAP_USE_FLTK_PNG:BOOL=ON" BRANCH "master")
CACHE_ADD("SNAP_USE_FLTK_JPEG:BOOL=ON" BRANCH "master")
CACHE_ADD("SNAP_USE_FLTK_ZLIB:BOOL=ON" BRANCH "master")
CACHE_ADD("X11_Xft_LIB:FILEPATH=/usr/lib/libXft.so.2" BRANCH "master")
CACHE_ADD("X11_Xinerama_LIB:FILEPATH=/usr/lib/libXinerama.so.1" BRANCH "master")
