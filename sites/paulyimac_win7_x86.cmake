# Directory shortcuts
SET(VCDIR "C:/Program Files (x86)/Microsoft Visual Studio 10.0")
SET(SDKDIR "C:/Program Files/Microsoft SDKs/Windows/v7.1")
SET(DOTNETDIR "C:/WINDOWS/Microsoft.NET/Framework")

# Root directory
SET(ROOT "C:/Users/picsl/tk/itksnap/cdash")

# Build configuration
SET(CONFIG "nmake32rel")

# Where CVS is
SET (CTEST_CVS_COMMAND "C:/cygwin/bin/cvs.exe")
SET (CTEST_CVS_CHECKOUT  "${CTEST_CVS_COMMAND} -z3 -d:ext:pyushkevich@itk-snap.cvs.sourceforge.net:/cvsroot/itk-snap co itksnap")

# what cmake command to use for configuring this dashboard
SET (CTEST_CMAKE_COMMAND "cmake.exe")
SET (CTEST_CTEST_COMMAND "ctest.exe")
SET (CTEST_MAKE_COMMAND "nmake.exe")

# Initial Cache
SET (CTEST_INITIAL_CACHE "
MAKECOMMAND:STRING=nmake -i 
CMAKE_MAKE_PROGRAM:FILEPATH=${VCDIR}/VC/bin/nmake.exe
CMAKE_C_COMPILER:FILEPATH=${VCDIR}/VC/bin/cl.exe
CMAKE_C_FLAGS:STRING= /DWIN32 /D_WINDOWS /W3 /Zm1000 /D_CRT_SECURE_NO_WARNINGS
CMAKE_CXX_COMPILER:FILEPATH=${VCDIR}/VC/bin/cl.exe
CMAKE_CXX_FLAGS:STRING= /DWIN32 /D_WINDOWS /W3 /Zm1000 /EHsc /GR /D_CRT_SECURE_NO_WARNINGS
CMAKE_GENERATOR:INTERNAL=NMake Makefiles
CMAKE_RC_COMPILER:FILEPATH=${SDKDIR}/bin/RC.Exe
BUILDNAME:STRING=Win7-vc10rel-x86
SITE:STRING=paulyimac_win7
CVSCOMMAND:FILEPATH=C:/cygwin/bin/cvs.exe
CMAKE_BUILD_TYPE:STRING=Release
FLTK_BASE_LIBRARY:FILEPATH=C:/Users/picsl/tk/fltk13_32bit/fltk-1.3.x-r7710/lib/fltk.lib
SNAP_USE_FLTK_PNG:BOOL=ON
SNAP_USE_FLTK_JPEG:BOOL=ON
SNAP_USE_FLTK_ZLIB:BOOL=ON
ITK_DIR:PATH=C:/Users/picsl/tk/itk320/bin32
VTK_DIR:PATH=C:/Users/picsl/tk/vtk56/bin32
VCREDIST_EXE:FILEPATH=C:/Program Files/Microsoft SDKs/Windows/v7.1/Redist/VC/vcredist_x86.exe
SCP_USERNAME:STRING=pyushkevich
SCP_PROGRAM:STRING=c:/cygwin/bin/scp.exe
")

# set any extra environment variables to use during the execution of the script here:
SET (CTEST_ENVIRONMENT 
	"PATH=${DOTNETDIR}/v4.0.30319\;${DOTNETDIR}/v3.5\;\;${VCDIR}/Common7/IDE\;${VCDIR}/Common7/Tools\;\;${VCDIR}/VC/Bin\;${VCDIR}/VC/Bin/VCPackages\;\;${SDKDIR}/Bin/NETFX 4.0 Tools\;${SDKDIR}/Bin\;\;C:/Windows/system32\;C:/Windows\;C:/Windows/System32/Wbem\;C:/Windows/System32/WindowsPowerShell/v1.0/\;C:/cygwin/bin\;C:/Program Files(x86)/CMake 2.6/bin"
	"INCLUDE=${VCDIR}/VC/INCLUDE\;${SDKDIR}/INCLUDE\;${SDKDIR}/INCLUDE/gl\;"
	"LIB=${VCDIR}/VC/Lib\;${SDKDIR}/Lib\;${DOTNETDIR}/v4.0.30319\;${DOTNETDIR}/v3.5"
	"LIBPATH=${DOTNETDIR}/v4.0.30319\;${DOTNETDIR}/v3.5\;${VCDIR}/VC/Lib\;"
	"WindowsSDKDir=${SDKDIR}"
	"CURRENT_CPU=x64"
	"TARGET_CPU=x86"
	"TARGET_PLATFORM=WIN7"
	"ToolsVersion=4.0"
	"Configuration=Release"
	"PlatformToolset=Windows7.1SDK"
	"FrameworkVersion=v4.0.30319"
	"sdkdir=C:/Program Files/Microsoft SDKs/Windows/v7.1/"
	"CVS_RSH=/bin/ssh.exe"
	"CC=${VCDIR}/VC/Bin/cl.exe"
	"CXX=${VCDIR}/VC/Bin/cl.exe"
	)

