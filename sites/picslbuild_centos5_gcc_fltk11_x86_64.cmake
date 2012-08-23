# Root directory
SET(ROOT "/mnt/build/pauly/itksnap/cdash")

# Build configuration
SET(CONFIG "gcc64rel_fltk11")

# Not for uploading
SET(SKIP_UPLOAD ON)

# Where CVS is
SET (CTEST_CVS_COMMAND "/usr/bin/cvs")
SET (CTEST_CVS_CHECKOUT  "${CTEST_CVS_COMMAND} -d:ext:pyushkevich@itk-snap.cvs.sourceforge.net:/cvsroot/itk-snap co itksnap")

# what cmake command to use for configuring this dashboard
SET (CMAKE_DIR "/mnt/pkg/cmake/cmake-2.6.4-Linux-i386")
SET (CTEST_CMAKE_COMMAND "${CMAKE_DIR}/bin/cmake")
SET (CTEST_CTEST_COMMAND "${CMAKE_DIR}/bin/ctest")
SET (CTEST_MAKE_COMMAND "/usr/bin/make")

# Initial Cache
SET (CTEST_INITIAL_CACHE "
MAKECOMMAND:STRING=/usr/bin/gmake -i -j 6
CMAKE_MAKE_PROGRAM:FILEPATH=/usr/bin/gmake
CMAKE_GENERATOR:INTERNAL=Unix Makefiles
BUILDNAME:STRING=CentOS-5.3-gccrel64
SITE:STRING=picsl-build.uphs.upenn.edu
CVSCOMMAND:FILEPATH=/usr/bin/cvs
CMAKE_BUILD_TYPE:STRING=Release
CMAKE_C_FLAGS:STRING=-fno-strict-aliasing
CMAKE_CXX_FLAGS:STRING=-fno-strict-aliasing
SNAP_USE_FLTK_1_1:BOOL=ON
FLTK_BASE_LIBRARY:FILEPATH=/mnt/build/pauly/fltk11/gcc64rel/bin/libfltk.a
ITK_DIR:PATH=/mnt/build/pauly/itk320/gcc64rel
VTK_DIR:PATH=/mnt/build/pauly/vtk561/gcc64rel
SCP_USERNAME:STRING=pyushkevich
")

# set any extra environment variables to use during the execution of the script here:
SET (CTEST_ENVIRONMENT "CVS_RSH=ssh")
