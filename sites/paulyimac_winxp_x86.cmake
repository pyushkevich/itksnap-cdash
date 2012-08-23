# Directory shortcuts
SET(VCDIR "C:/Program Files/Microsoft Visual Studio 9.0")
SET(SDKDIR "C:/Program Files/Microsoft SDKs/Windows/v6.0A")
SET(DOTNETDIR "C:/WINDOWS/Microsoft.NET/Framework")

# Root directory
SET(ROOT "E:/tk/itksnap/cdash")

# Build configuration
SET(CONFIG "nmake32rel")

# No uploads for this build
SET(SKIP_UPLOAD ON)

# Where CVS is
SET (CTEST_CVS_COMMAND "C:/cygwin/bin/cvs.exe")
SET (CTEST_CVS_CHECKOUT  "${CTEST_CVS_COMMAND} -z3 -d:ext:pyushkevich@itk-snap.cvs.sourceforge.net:/cvsroot/itk-snap co itksnap")

# what cmake command to use for configuring this dashboard
SET (CTEST_CMAKE_COMMAND "cmake.exe")
SET (CTEST_CTEST_COMMAND "ctest.exe")
SET (CTEST_MAKE_COMMAND "nmake.exe")

# Initial Cache
SET (CTEST_INITIAL_CACHE "
MAKECOMMAND:STRING=${VCDIR}/VC/bin/nmake.exe -i
CMAKE_C_COMPILER:FILEPATH=${VCDIR}/VC/bin/cl.exe
CMAKE_C_FLAGS:STRING= /DWIN32 /D_WINDOWS /W3 /Zm1000 /D_CRT_SECURE_NO_WARNINGS
CMAKE_CXX_COMPILER:FILEPATH=${VCDIR}/VC/bin/cl.exe
CMAKE_CXX_FLAGS:STRING= /DWIN32 /D_WINDOWS /W3 /Zm1000 /EHsc /GR /D_CRT_SECURE_NO_WARNINGS
CMAKE_MAKE_PROGRAM:FILEPATH=${VCDIR}/VC/bin/nmake.exe
CMAKE_GENERATOR:INTERNAL=NMake Makefiles
CMAKE_RC_COMPILER:FILEPATH=${SDKDIR}/bin/RC.Exe
BUILDNAME:STRING=WinXP-vc9rel32
SITE:STRING=paulyimac_winxp
CVSCOMMAND:FILEPATH=C:/cygwin/bin/cvs.exe
CMAKE_BUILD_TYPE:STRING=Release
FLTK_BASE_LIBRARY:PATH=E:/tk/fltk13/fltk-1.3.x-r7710/lib/fltk.lib
SNAP_USE_FLTK_PNG:BOOL=ON
SNAP_USE_FLTK_JPEG:BOOL=ON
SNAP_USE_FLTK_ZLIB:BOOL=ON
ITK_DIR:PATH=E:/tk/itk320/inst32/lib/InsightToolkit
VTK_DIR:PATH=E:/tk/vtk561/inst32/lib/vtk-5.6
VCREDIST_X86:FILEPATH=C:/Documents and Settings/Hui Zhang/My Documents/ITKSNAP/misc/vcredist_x86.exe
SCP_USERNAME:STRING=pyushkevich
SCP_PROGRAM:STRING=c:/cygwin/bin/scp.exe
")

# set any extra environment variables to use during the execution of the script here:
SET (CTEST_ENVIRONMENT 
	"PATH=${VCDIR}/Common7/IDE\;${VCDIR}/VC/BIN\;${VCDIR}/Common7/Tools\;${DOTNETDIR}/v3.5\;${DOTNETDIR}/v2.0.50727\;${VCDIR}/VC/VCPackages\;${SDKDIR}/bin\;C:/WINDOWS/system32\;C:/WINDOWS\;C:/WINDOWS/System32/Wbem\;c:/cygwin/bin\;C:/Program Files/CMake 2.6/bin"
	"INCLUDE=${VCDIR}/VC/INCLUDE"
	"INCLUDE=${VCDIR}/VC/INCLUDE\;${SDKDIR}/include"
	"LIB=${VCDIR}/VC/LIB\;${SDKDIR}/lib"
	"LIBPATH=${DOTNETDIR}/v3.5\;${DOTNETDIR}/v2.0.50727\;${VCDIR}/VC/LIB"
	"CVS_RSH=ssh"
)
