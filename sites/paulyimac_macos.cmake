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
SET(ROOT "/Users/pauly/tk/buildbot")

# REQUIRED: define the descriptive site name and build name
set(CTEST_SITE "paulyimac_macos")
set(CTEST_BUILD_NAME "MacOS-10.5-${IN_CONFIG}")

# REQUIRED: Where GIT is and who is the user with SSH capability
SET(GIT_BINARY /usr/local/git/bin/git)
SET(GIT_UID pyushkevich)

# This site uploads all of its builds
SET(DO_UPLOAD TRUE)

# Library directory: path where all the libraries are build (this is only used internally)
SET(TKDIR "/Users/pauly/tk")

# Depending on the configuration, set the library paths for this machine
# as well as some other settings
IF(${IN_CONFIG} MATCHES gcc32rel)

  SET(FLTK13 "${TKDIR}/fltk13/install32/lib/libfltk.a")
  SET(ARCH i386)
  SET(MINVER 10.4)

ELSEIF(${IN_CONFIG} MATCHES gcc64rel)
  
  SET(FLTK13 "${TKDIR}/fltk13/install64/lib/libfltk.a")
  SET(ARCH x86_64)
  SET(MINVER 10.5)

ELSE(${IN_CONFIG} MATCHES gcc32rel)
  
  MESSAGE(FATAL_ERROR "Unknown configuration ${IN_CONFIG}")

ENDIF(${IN_CONFIG} MATCHES gcc32rel)

# Add cache entries
CACHE_ADD("MAKECOMMAND:STRING=/usr/bin/make -i")
CACHE_ADD("CMAKE_MAKE_PROGRAM:FILEPATH=/usr/bin/make")
CACHE_ADD("CMAKE_BUILD_TYPE:STRING=Release")
CACHE_ADD("CMAKE_C_FLAGS:STRING=-mmacosx-version-min=${MINVER}")
CACHE_ADD("CMAKE_CXX_FLAGS:STRING=-mmacosx-version-min=${MINVER}")
CACHE_ADD("CMAKE_OSX_ARCHITECTURES:STRING=${ARCH}")
CACHE_ADD("ITK_DIR:PATH=${TKDIR}/itk42/${IN_CONFIG}")
CACHE_ADD("VTK_DIR:PATH=${TKDIR}/vtk580/${IN_CONFIG}" BRANCH "qtsnap.*")
CACHE_ADD("VTK_DIR:PATH=${TKDIR}/vtk561/${IN_CONFIG}" BRANCH "master")
CACHE_ADD("FLTK_BASE_LIBRARY:FILEPATH=${FLTK13}" BRANCH "master")
CACHE_ADD("SNAP_USE_FLTK_PNG:BOOL=ON" BRANCH "master")
CACHE_ADD("SNAP_USE_FLTK_JPEG:BOOL=ON" BRANCH "master")
