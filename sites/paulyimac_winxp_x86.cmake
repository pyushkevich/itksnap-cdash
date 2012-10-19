# This script should be edited for each new site where
# we want to build ITK-SNAP and related tools. The
# general structure of this script should be followed on
# all sites, but some additonal variables (e.g., CTEST_ENVIRONMENT)
# may need to be set on some platforms and configurations

# Root directory
SET(ROOT "C:/picsl/tk/buildbot")

# REQUIRED: define the descriptive site name and build name
set(CTEST_SITE "paulyimac_winxp_x86")
set(CTEST_BUILD_NAME "WinXP-vc9-${IN_CONFIG}")

# REQUIRED: Where GIT is and who is the user with SSH capability
SET(GIT_BINARY "C:/Program Files/Git/bin/git")
SET(GIT_UID octaviansoldea)

# This site uploads all of its builds
SET(DO_UPLOAD TRUE)

# Library directory: path where all the libraries are build (this is only used internally)
SET(TKDIR "C:/picsl/tk")

# Directory shortcuts
SET(VCDIR "C:/Program Files/Microsoft Visual Studio 9.0")
SET(SDKDIR "C:/Program Files/Microsoft SDKs/Windows/v6.0A")
SET(DOTNETDIR "C:/WINDOWS/Microsoft.NET/Framework")
SET(CMAKEDIR "C:/Program Files (x86)/CMake 2.8")
#SET(DOTNET64DIR "C:/WINDOWS/Microsoft.NET/Framework64")

# Build configuration
#SET(CONFIG "nmake32rel")

# No uploads for this build
#SET(SKIP_UPLOAD ON)

# what cmake command to use for configuring this dashboard
#SET (CTEST_CMAKE_COMMAND "cmake.exe")
#SET (CTEST_CTEST_COMMAND "ctest.exe")
#SET (CTEST_MAKE_COMMAND "nmake.exe")

SET(MYBIN "bin32")
SET(VCBINDIR "${VCDIR}/VC/Bin")
SET(SDKBINDIR "${SDKDIR}/bin")
SET(WINSUFFIX "x86")

ENV_ADD(PATH "${DOTNETDIR}/v2.0.50727\;${DOTNETDIR}/v3.5\;\;${VCDIR}/Common7/IDE\;${VCDIR}/Common7/Tools\;\;${VCDIR}/VC/Bin\;${VCDIR}/VC/Bin/VCPackages\;\;${SDKDIR}/Bin/NETFX 4.0 Tools\;${SDKDIR}/Bin\;\;C:/Windows/system32\;C:/Windows\;C:/Windows/System32/Wbem\;C:/Windows/System32/WindowsPowerShell/v1.0/\;C:/cygwin/bin\;${CMAKEDIR}/bin")
ENV_ADD(INCLUDE "${VCDIR}/VC/INCLUDE\;${SDKDIR}/INCLUDE\;${SDKDIR}/INCLUDE/gl\;")
ENV_ADD(LIB "${VCDIR}/VC/Lib\;${SDKDIR}/Lib\;${DOTNETDIR}/v2.0.50727\;${DOTNETDIR}/v3.5")
ENV_ADD(LIBPATH "${DOTNETDIR}/v2.0.50727\;${DOTNETDIR}/v3.5\;${VCDIR}/VC/Lib\;")
ENV_ADD(WindowsSDKDir "${SDKDIR}")
#ENV_ADD(CURRENT_CPU "x64")
ENV_ADD(TARGET_CPU "x86")
ENV_ADD(TARGET_PLATFORM "WINXP")
#ENV_ADD(ToolsVersion "4.0")
ENV_ADD(ToolsVersion "3.5")
ENV_ADD(Configuration "Release")
ENV_ADD(PlatformToolset "Windows6.0ASDK")
ENV_ADD(FrameworkVersion "v2.0.50727")
ENV_ADD(sdkdir "C:/Program Files/Microsoft SDKs/Windows/v6.0A/")
ENV_ADD(CVS_RSH "/bin/ssh.exe")
ENV_ADD(CC "${VCDIR}/VC/Bin/cl.exe")
ENV_ADD(CXX "${VCDIR}/VC/Bin/cl.exe")

# Set the Generator
SET(CTEST_CMAKE_GENERATOR "NMake Makefiles")


# Add cache entries
CACHE_ADD("MAKECOMMAND:STRING=nmake -i ")
CACHE_ADD("CMAKE_MAKE_PROGRAM:FILEPATH=${VCBINDIR}/nmake.exe")
CACHE_ADD("CMAKE_C_COMPILER:FILEPATH=${VCBINDIR}/cl.exe")
CACHE_ADD("CMAKE_C_FLAGS:STRING= /DWIN32 /D_WINDOWS /W3 /Zm1000 /D_CRT_SECURE_NO_WARNINGS /wd4250")
CACHE_ADD("CMAKE_CXX_COMPILER:FILEPATH=${VCBINDIR}/cl.exe")
CACHE_ADD("CMAKE_CXX_FLAGS:STRING= /DWIN32 /D_WINDOWS /W3 /Zm1000 /EHsc /GR /D_CRT_SECURE_NO_WARNINGS /wd4250")
CACHE_ADD("CMAKE_RC_COMPILER:FILEPATH=${SDKBINDIR}/RC.Exe")
CACHE_ADD("BUILDNAME:STRING=WinXP-${IN_CONFIG}")
CACHE_ADD("SITE:STRING=paulyimac_winxp")
CACHE_ADD("CMAKE_BUILD_TYPE:STRING=Release")
CACHE_ADD("FLTK_BASE_LIBRARY:FILEPATH=C:/picsl/tk/fltk/install-bin32/lib/fltk.lib")
CACHE_ADD("SNAP_USE_FLTK_PNG:BOOL=ON")
CACHE_ADD("SNAP_USE_FLTK_JPEG:BOOL=ON")
CACHE_ADD("SNAP_USE_FLTK_ZLIB:BOOL=ON")
CACHE_ADD("ITK_DIR:PATH=C:/picsl/tk/itk/bin32/${MYBIN}")
CACHE_ADD("VTK_DIR:PATH=C:/picsl/tk/vtk/${MYBIN}" BRANCH "master")
#CACHE_ADD("VCREDIST_EXE:FILEPATH=${SDKDIR}/Redist/VC/vcredist_${WINSUFFIX}.exe")
CACHE_ADD("VCREDIST_EXE:FILEPATH=C:/Documents and Settings/Hui Zhang/My Documents/ITKSNAP/misc/vcredist_x86.exe")
CACHE_ADD("SCP_PROGRAM:STRING=c:/cygwin/bin/scp.exe")

# Initial Cache
#SET (CTEST_INITIAL_CACHE "


#VCREDIST_X86:FILEPATH=C:/Documents and Settings/Hui Zhang/My Documents/ITKSNAP/misc/vcredist_x86.exe
#SCP_USERNAME:STRING=octaviansoldea
#")
