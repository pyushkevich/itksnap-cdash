# Root directory
SET(ROOT "/home/pauly/tk/itksnap/cdash/")

# Build configuration
SET(CONFIG "gcc32rel")

# Where CVS is
SET (CTEST_CVS_COMMAND "/usr/bin/cvs")
SET (CTEST_CVS_CHECKOUT  "${CTEST_CVS_COMMAND} -d:ext:pyushkevich@itk-snap.cvs.sourceforge.net:/cvsroot/itk-snap co itksnap")

# what cmake command to use for configuring this dashboard
SET (CTEST_CMAKE_COMMAND "/usr/local/bin/cmake")
SET (CTEST_CTEST_COMMAND "/usr/local/bin/ctest")
SET (CTEST_MAKE_COMMAND "/usr/bin/make")

# Initial Cache
SET (CTEST_INITIAL_CACHE "
MAKECOMMAND:STRING=/usr/bin/make -i
CMAKE_MAKE_PROGRAM:FILEPATH=/usr/bin/make
CMAKE_GENERATOR:INTERNAL=Unix Makefiles
BUILDNAME:STRING=CentOS-5.2-gccrel32
SITE:STRING=paulyimac_centos5_x86
CVSCOMMAND:FILEPATH=/usr/bin/cvs
CMAKE_BUILD_TYPE:STRING=Release
CMAKE_C_FLAGS:STRING=-fno-strict-aliasing
CMAKE_CXX_FLAGS:STRING=-fno-strict-aliasing
FLTK_BASE_LIBRARY:FILEPATH=/home/pauly/tk/fltk13/install/lib/libfltk.a
X11_Xinerama_LIB:FILEPATH=/usr/lib/libXinerama.so.1
ITK_DIR:PATH=/home/pauly/tk/itk320/gcc32rel
VTK_DIR:PATH=/home/pauly/tk/vtk561/gcc32rel
SCP_USERNAME:STRING=pyushkevich
")

# set any extra environment variables to use during the execution of the script here:
SET (CTEST_ENVIRONMENT "CVS_RSH=ssh")
