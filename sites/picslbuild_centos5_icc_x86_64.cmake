# Root directory
SET(ROOT "/mnt/build/pauly/itksnap/cdash")

# Build configuration
SET(CONFIG "icc64rel")

# No uploads
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
MAKECOMMAND:STRING=/usr/bin/gmake -i
CMAKE_MAKE_PROGRAM:FILEPATH=/usr/bin/gmake
CMAKE_GENERATOR:INTERNAL=Unix Makefiles
BUILDNAME:STRING=CentOS-5.3-iccrel64
SITE:STRING=picsl-build.uphs.upenn.edu
CVSCOMMAND:FILEPATH=/usr/bin/cvs
CMAKE_BUILD_TYPE:STRING=Release
CMAKE_C_FLAGS:STRING=-wd1268 -wd1224 -wd858
CMAKE_CXX_FLAGS:STRING=-wd1268 -wd1224 -wd858
FLTK_BASE_LIBRARY:FILEPATH=/mnt/build/pauly/fltk13/install-icc/lib/libfltk.a
ITK_DIR:PATH=/mnt/build/pauly/itk320/icc64rel
VTK_DIR:PATH=/mnt/build/pauly/vtk561/icc64rel
SCP_USERNAME:STRING=pyushkevich
")

# set any extra environment variables to use during the execution of the script here:
SET (CTEST_ENVIRONMENT 
  "CVS_RSH=ssh"
  "CC=/opt/intel/cce/10.1.018/bin/icc"
  "CXX=/opt/intel/cce/10.1.018/bin/icpc"
  "LD_LIBRARY_PATH=/opt/intel/cce/10.1.018/lib"
)
