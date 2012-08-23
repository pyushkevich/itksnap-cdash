# Root directory
SET(ROOT "/Users/pauly/tk/itksnap/cdash/")

# Build configuration
SET(CONFIG "gcc32rel")

# Where CVS is
SET (CTEST_CVS_COMMAND "/usr/bin/cvs")
SET (CTEST_CVS_CHECKOUT  "${CTEST_CVS_COMMAND} -d:ext:pyushkevich@itk-snap.cvs.sourceforge.net:/cvsroot/itk-snap co itksnap")

# what cmake command to use for configuring this dashboard
SET (CTEST_CMAKE_COMMAND "/usr/bin/cmake")
SET (CTEST_CTEST_COMMAND "/usr/bin/ctest")
SET (CTEST_MAKE_COMMAND "/usr/bin/make")

# Initial Cache
SET (CTEST_INITIAL_CACHE "
MAKECOMMAND:STRING=/usr/bin/make -i
CMAKE_MAKE_PROGRAM:FILEPATH=/usr/bin/make
CMAKE_GENERATOR:INTERNAL=Unix Makefiles
BUILDNAME:STRING=MacOS-10.5-gccrel32
SITE:STRING=paulyimac_macos
CVSCOMMAND:FILEPATH=/usr/bin/cvs
CMAKE_BUILD_TYPE:STRING=Release
CMAKE_OSX_ARCHITECTURES:STRING=i386
CMAKE_C_FLAGS:STRING=-mmacosx-version-min=10.4
CMAKE_CXX_FLAGS:STRING=-mmacosx-version-min=10.4
FLTK_BASE_LIBRARY:FILEPATH=/Users/pauly/tk/fltk13/gcc32rel/lib/libfltk.a
FLTK_INCLUDE_DIR:FILEPATH=/Users/pauly/tk/fltk13/fltk-1.3.0rc3
SNAP_USE_FLTK_PNG:BOOL=ON
SNAP_USE_FLTK_JPEG:BOOL=ON
ITK_DIR:PATH=/Users/pauly/tk/itk320/gcc32rel
VTK_DIR:PATH=/Users/pauly/tk/vtk561/gcc32rel
SCP_USERNAME:STRING=pyushkevich
")

# set any extra environment variables to use during the execution of the script here:
SET (CTEST_ENVIRONMENT "CVS_RSH=ssh")
