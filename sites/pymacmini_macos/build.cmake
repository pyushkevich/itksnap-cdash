#############################################
# Site-Specific Build Configuration Script  #
#############################################
#
# This script should be edited for each new site where
# we want to build ITK-SNAP and related tools. The
# general structure of this script should be followed on
# all sites, but some additonal variables (e.g., CTEST_ENVIRONMENT)
# may need to be set on some platforms and configurations

# This site uploads all of its builds
SET(DO_UPLOAD ON)

# Mac Framework directory
SET(MINVER 10.7)

# Depending on the configuration, set the library paths for this machine
# as well as some other settings
SETCOND(ARCH i386 CONFIG "xc32.*")
SETCOND(ARCH x86_64 CONFIG "xc64.*")

ENV_ADD(MAKEFLAGS "-j 8")

# Add general cache entries
CACHE_ADD("MAKECOMMAND:STRING=/usr/bin/make -i -j 8")
CACHE_ADD("CMAKE_MAKE_PROGRAM:FILEPATH=/usr/bin/make")
CACHE_ADD("CMAKE_BUILD_TYPE:STRING=Release")
CACHE_ADD("ARCH:STRING=${ARCH}")
CACHE_ADD("CMAKE_OSX_ARCHITECTURES:STRING=${ARCH}")
CACHE_ADD("BUILD_GUI:BOOL=ON" PRODUCT "c3d")

# Support for code signing
CACHE_ADD("SNAP_MACOSX_CODESIGN_CERT:STRING=Developer ID Application: Paul Yushkevich (5A636Q488D)")

# Library directory: path where all the libraries are build (this is only used internally)
SET(TKDIR "/Users/picsl/tk")

# Add product-specific cache entries
IF(NEED_FLTK)
  SET(FLTK13 "${TKDIR}/fltk/install/lib/libfltk.a")
  CACHE_ADD("FLTK_BASE_LIBRARY:FILEPATH=${FLTK13}")
  CACHE_ADD("SNAP_USE_FLTK_PNG:BOOL=ON")
  CACHE_ADD("SNAP_USE_FLTK_JPEG:BOOL=ON")
ENDIF(NEED_FLTK)

IF(NEED_QT4)
  CACHE_ADD("QT_QMAKE_EXECUTABLE:FILEPATH=${TKDIR}/qt48/install/bin/qmake")
ELSEIF(NEED_QT5)
  SETCOND(SKIP_BUILD ON CONFIG "xc32.*")
  CACHE_ADD("CMAKE_PREFIX_PATH:STRING=${TKDIR}/Qt5/5.3/clang_64/lib/cmake")
ELSEIF(NEED_QT54)
  SETCOND(SKIP_BUILD ON CONFIG "xc32.*")
  CACHE_ADD("CMAKE_PREFIX_PATH:STRING=${TKDIR}/Qt5.4/5.4/clang_64/lib/cmake")
ELSEIF(NEED_QT56)
  SETCOND(SKIP_BUILD ON CONFIG "xc32.*")
  CACHE_ADD("CMAKE_PREFIX_PATH:STRING=${TKDIR}/Qt/5.6/clang_64/lib/cmake")
ELSEIF(NEED_QT515)
  SETCOND(SKIP_BUILD ON CONFIG "xc32.*")
  CACHE_ADD("CMAKE_PREFIX_PATH:FILEPATH=${TKDIR}/Qt2021/5.12.10/clang_64/lib/cmake")
ELSEIF(NEED_QT6)
  # Machine too old for Qt6
  SETCOND(SKIP_BUILD ON)
ENDIF(NEED_QT4)
