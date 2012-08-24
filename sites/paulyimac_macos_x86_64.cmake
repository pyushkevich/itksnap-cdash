# Root directory
SET(ROOT "/Users/pauly/tk/itksnap/cdash/")

# Build configuration
SET(CONFIG "gcc64rel")

# CMake generator
SET(CTEST_CMAKE_GENERATOR "Unix Makefiles")

# Who we are
set(CTEST_SITE "paulyimac_macos")
set(CTEST_BUILD_NAME "MacOS-10.5-gccrel32")

# Where GIT is
SET (GIT_BINARY /usr/local/git/bin/git)
SET (GIT_UID pyushkevich)

# Initial Cache
SET (INIT_CACHE "
MAKECOMMAND:STRING=/usr/bin/make -i
CMAKE_MAKE_PROGRAM:FILEPATH=/usr/bin/make
CMAKE_GENERATOR:INTERNAL=Unix Makefiles
BUILDNAME:STRING=MacOS-10.5-gccrel64
SITE:STRING=paulyimac_macos
CMAKE_BUILD_TYPE:STRING=Release
CMAKE_OSX_ARCHITECTURES:STRING=x86_64
CMAKE_C_FLAGS:STRING=-mmacosx-version-min=10.5
CMAKE_CXX_FLAGS:STRING=-mmacosx-version-min=10.5
FLTK_BASE_LIBRARY:FILEPATH=/Users/pauly/tk/fltk13/install64/lib/libfltk.a
SNAP_USE_FLTK_PNG:BOOL=ON
SNAP_USE_FLTK_JPEG:BOOL=ON
ITK_DIR:PATH=/Users/pauly/tk/itk320/gcc64rel
VTK_DIR:PATH=/Users/pauly/tk/vtk561/gcc64rel
SCP_USERNAME:STRING=pyushkevich
")
