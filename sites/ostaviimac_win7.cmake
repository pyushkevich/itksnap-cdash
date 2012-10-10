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
SET(ROOT "C:/Users/octavian/tk/buildbot")

# REQUIRED: define the descriptive site name and build name
set(CTEST_SITE "ostaviimac_win7")
set(CTEST_BUILD_NAME "Win7-vc10-${IN_CONFIG}")

# REQUIRED: Where GIT is and who is the user with SSH capability
SET(GIT_BINARY "C:/Program Files (x86)/Git/bin/git")
SET(GIT_UID octaviansoldea)

# This site uploads all of its builds
SET(DO_UPLOAD TRUE)

# Library directory: path where all the libraries are build (this is only used internally)
SET(TKDIR "C:/Users/octavian/tk")

# Directory shortcuts
SET(VCDIR "C:/Program Files (x86)/Microsoft Visual Studio 10.0")
SET(SDKDIR "C:/Program Files/Microsoft SDKs/Windows/v7.1")
SET(DOTNETDIR "C:/WINDOWS/Microsoft.NET/Framework")
SET(CMAKEDIR "C:/Program Files (x86)/CMake 2.8")
SET(DOTNET64DIR "C:/WINDOWS/Microsoft.NET/Framework64")

# Depending on the configuration, set the library paths for this machine
# as well as some other settings
IF(${IN_CONFIG} MATCHES vce64rel)

  SET(MYBIN "bin64")
  SET(VCBINDIR "${VCDIR}/VC/bin/amd64")
  SET(SDKBINDIR "${SDKDIR}/bin/x64")
  SET(WINSUFFIX "x64")

  ENV_ADD(PATH "${DOTNET64DIR}/v4.0.30319\;${DOTNETDIR}/v4.0.30319\;${DOTNET64DIR}/v3.5\;${DOTNETDIR}/v3.5\;${VCDIR}/Common 7/IDE\;${VCDIR}/Common7/Tools\;${VCDIR}/VC/Bin/amd64\;${VCDIR}/VC/Bin/VCPackages\;${SDKDIR}/Bin/NETFX 4.0 Tools/x64\;${SDKDIR}/Bin/x64\;${SDKDIR}/Bin\;C:/Windows/system32\;C:/Windows\;C:/Windows/System32/Wbem\;C:/Windows/System32/WindowsPowerShell/v1.0/\;C:/cygwin/bin\;${CMAKEDIR}/bin")
  ENV_ADD(INCLUDE "${VCDIR}/VC/INCLUDE\;${SDKDIR}/INCLUDE\;${SDKDIR}/INCLUDE/gl\;")
  ENV_ADD(LIB "${VCDIR}/VC/Lib/amd64\;${SDKDIR}/Lib/X64\;")
  ENV_ADD(LIBPATH "${DOTNET64DIR}/v4.0.30319\;${DOTNETDIR}/v4.0.30319\;${DOTNET64DIR}/v3.5\;${DOTNETDIR}/v3.5\;${VCDIR}/VC/Lib/amd64\;")
  ENV_ADD(WindowsSDKDir "${SDKDIR}")
  ENV_ADD(CURRENT_CPU "x64")
  ENV_ADD(TARGET_CPU "x64")
  ENV_ADD(TARGET_PLATFORM "WIN7")
  ENV_ADD(ToolsVersion "4.0")
  ENV_ADD(Configuration ${CONFIGURATION})
  #ENV_ADD(Configuration "Release")
  ENV_ADD(PlatformToolset "Windows7.1SDK")
  ENV_ADD(CL "/AI C:/Windows/Microsoft.NET/Framework64/v4.0.30319")
  ENV_ADD(FrameworkVersion "v4.0.30319")
  ENV_ADD(sdkdir "C:/Program Files/Microsoft SDKs/Windows/v7.1/")

ELSEIF(${IN_CONFIG} MATCHES vce32rel)

  SET(MYBIN "bin32")
  SET(VCBINDIR "${VCDIR}/VC/Bin")
  SET(SDKBINDIR "${SDKDIR}/bin")
  SET(WINSUFFIX "x86")

  ENV_ADD(PATH "${DOTNETDIR}/v4.0.30319\;${DOTNETDIR}/v3.5\;\;${VCDIR}/Common7/IDE\;${VCDIR}/Common7/Tools\;\;${VCDIR}/VC/Bin\;${VCDIR}/VC/Bin/VCPackages\;\;${SDKDIR}/Bin/NETFX 4.0 Tools\;${SDKDIR}/Bin\;\;C:/Windows/system32\;C:/Windows\;C:/Windows/System32/Wbem\;C:/Windows/System32/WindowsPowerShell/v1.0/\;C:/cygwin/bin\;${CMAKEDIR}/bin")
  ENV_ADD(INCLUDE "${VCDIR}/VC/INCLUDE\;${SDKDIR}/INCLUDE\;${SDKDIR}/INCLUDE/gl\;")
  ENV_ADD(LIB "${VCDIR}/VC/Lib\;${SDKDIR}/Lib\;${DOTNETDIR}/v4.0.30319\;${DOTNETDIR}/v3.5")
  ENV_ADD(LIBPATH "${DOTNETDIR}/v4.0.30319\;${DOTNETDIR}/v3.5\;${VCDIR}/VC/Lib\;")
  ENV_ADD(WindowsSDKDir "${SDKDIR}")
  ENV_ADD(CURRENT_CPU "x64")
  ENV_ADD(TARGET_CPU "x86")
  ENV_ADD(TARGET_PLATFORM "WIN7")
  ENV_ADD(ToolsVersion "4.0")
  ENV_ADD(Configuration "Release")
  ENV_ADD(PlatformToolset "Windows7.1SDK")
  ENV_ADD(FrameworkVersion "v4.0.30319")
  ENV_ADD(sdkdir "C:/Program Files/Microsoft SDKs/Windows/v7.1/")
  ENV_ADD(CVS_RSH "/bin/ssh.exe")
  ENV_ADD(CC "${VCDIR}/VC/Bin/cl.exe")
  ENV_ADD(CXX "${VCDIR}/VC/Bin/cl.exe")

ELSE(${IN_CONFIG} MATCHES vce64rel)
  
  MESSAGE(FATAL_ERROR "Unknown configuration ${IN_CONFIG}")

ENDIF(${IN_CONFIG} MATCHES vce64rel)

# Set the Generator
SET(CTEST_CMAKE_GENERATOR "NMake Makefiles")

# Add cache entries
CACHE_ADD("MAKECOMMAND:STRING=nmake -i ")
CACHE_ADD("CMAKE_MAKE_PROGRAM:FILEPATH=${VCBINDIR}/nmake.exe")
CACHE_ADD("CMAKE_C_COMPILER:FILEPATH=${VCBINDIR}/cl.exe")
CACHE_ADD("CMAKE_C_FLAGS:STRING= /DWIN32 /D_WINDOWS /W3 /Zm1000 /D_CRT_SECURE_NO_WARNINGS")
CACHE_ADD("CMAKE_CXX_COMPILER:FILEPATH=${VCBINDIR}/cl.exe")
CACHE_ADD("CMAKE_CXX_FLAGS:STRING= /DWIN32 /D_WINDOWS /W3 /Zm1000 /EHsc /GR /D_CRT_SECURE_NO_WARNINGS")
CACHE_ADD("CMAKE_RC_COMPILER:FILEPATH=${SDKBINDIR}/RC.Exe")
CACHE_ADD("BUILDNAME:STRING=Win7-vce10-${IN_CONFIG}")
CACHE_ADD("SITE:STRING=ostaviimac_win7")
CACHE_ADD("CMAKE_BUILD_TYPE:STRING=Release")
#CACHE_ADD("FLTK_BASE_LIBRARY:FILEPATH=C:/Users/octavian/tk/fltk13/install-${MYBIN}/lib/fltk.lib")
CACHE_ADD("FLTK_BASE_LIBRARY:FILEPATH=C:/Users/octavian/tk/fltk13/bin64/lib/fltk.lib")
CACHE_ADD("QT_QMAKE_EXECUTABLE:FILEPATH=${TKDIR}/Qt/${MYBIN}/qt-everywhere-opensource-src-4.8.2/bin/qmake.exe")
CACHE_ADD("SNAP_USE_FLTK_PNG:BOOL=ON")
CACHE_ADD("SNAP_USE_FLTK_JPEG:BOOL=ON")
CACHE_ADD("SNAP_USE_FLTK_ZLIB:BOOL=ON")
#CACHE_ADD("ITK_DIR:PATH=C:/Users/octavian/tk/itk420/${MYBIN}")
CACHE_ADD("ITK_DIR:PATH=C:/Users/octavian/tk/itk420/bin64")
#CACHE_ADD("VTK_DIR:PATH=C:/Users/octavian/tk/vtk561/${MYBIN}" BRANCH "master")
CACHE_ADD("VTK_DIR:PATH=C:/Users/octavian/tk/vtk561/bin64" BRANCH "master")

CACHE_ADD("VTK_DIR:PATH=C:/Users/octavian/tk/vtk58/${MYBIN}" BRANCH "qtsnap.*")
CACHE_ADD("VCREDIST_EXE:FILEPATH=${SDKDIR}/Redist/VC/vcredist_${WINSUFFIX}.exe")
CACHE_ADD("SCP_PROGRAM:STRING=c:/cygwin/bin/scp.exe")

CACHE_ADD("FLTK_INCLUDE_DIR=C:/Users/octavian/tk/fltk13/fltk-1.3.0")
CACHE_ADD("FLTK_FLUID_EXECUTABLE:FILEPATH=C:/Users/octavian/tk/fltk13/bin64/bin/fluid.exe")