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
SET(ROOT "C:/Users/picsl/tk/buildbot")

# REQUIRED: define the descriptive site name and build name
set(CTEST_SITE "paulyimac_win7")
set(CTEST_BUILD_NAME "Win7-vc10-${IN_CONFIG}")

# REQUIRED: Where GIT is and who is the user with SSH capability
SET(GIT_BINARY "C:/Program Files (x86)/Git/bin/git")
SET(GIT_UID pyushkevich)

# This site uploads all of its builds
SET(DO_UPLOAD TRUE)

# Library directory: path where all the libraries are build (this is only used internally)
SET(TKDIR "C:/Users/picsl/tk")

# Directory shortcuts
SET(VCDIR "C:/Program Files (x86)/Microsoft Visual Studio 10.0")
SET(SDKDIR "C:/Program Files/Microsoft SDKs/Windows/v7.1")
SET(DOTNETDIR "C:/WINDOWS/Microsoft.NET/Framework")
SET(DOTNET64DIR "C:/WINDOWS/Microsoft.NET/Framework64")

# Depending on the configuration, set the library paths for this machine
# as well as some other settings
IF(${IN_CONFIG} MATCHES vcx64rel)

  SET(MYBIN "bin64")

ELSE(${IN_CONFIG} MATCHES vcx64rel)
  
  MESSAGE(FATAL_ERROR "Unknown configuration ${IN_CONFIG}")

ENDIF(${IN_CONFIG} MATCHES vcx64rel)

# Set the Generator
SET(CTEST_CMAKE_GENERATOR "NMake Makefiles")

# Add cache entries
CACHE_ADD("MAKECOMMAND:STRING=nmake -i ")
CACHE_ADD("CMAKE_MAKE_PROGRAM:FILEPATH=${VCDIR}/VC/bin/amd64/nmake.exe")
CACHE_ADD("CMAKE_C_COMPILER:FILEPATH=${VCDIR}/VC/bin/amd64/cl.exe")
CACHE_ADD("CMAKE_C_FLAGS:STRING= /DWIN32 /D_WINDOWS /W3 /Zm1000 /D_CRT_SECURE_NO_WARNINGS")
CACHE_ADD("CMAKE_CXX_COMPILER:FILEPATH=${VCDIR}/VC/bin/amd64/cl.exe")
CACHE_ADD("CMAKE_CXX_FLAGS:STRING= /DWIN32 /D_WINDOWS /W3 /Zm1000 /EHsc /GR /D_CRT_SECURE_NO_WARNINGS")
CACHE_ADD("CMAKE_RC_COMPILER:FILEPATH=${SDKDIR}/bin/x64/RC.Exe")
CACHE_ADD("BUILDNAME:STRING=Win7-vc10rel-${IN_CONFIG}")
CACHE_ADD("SITE:STRING=paulyimac_win7")
CACHE_ADD("CMAKE_BUILD_TYPE:STRING=Release")
CACHE_ADD("FLTK_BASE_LIBRARY:FILEPATH=C:/Users/picsl/tk/fltk13/fltk-1.3.x-r7710/lib/fltk.lib")
CACHE_ADD("SNAP_USE_FLTK_PNG:BOOL=ON")
CACHE_ADD("SNAP_USE_FLTK_JPEG:BOOL=ON")
CACHE_ADD("SNAP_USE_FLTK_ZLIB:BOOL=ON")
CACHE_ADD("ITK_DIR:PATH=C:/Users/picsl/tk/itk320/bin64")
CACHE_ADD("VTK_DIR:PATH=C:/Users/picsl/tk/vtk56/bin64")
CACHE_ADD("VCREDIST_EXE:FILEPATH=C:/Program Files/Microsoft SDKs/Windows/v7.1/Redist/VC/vcredist_x64.exe")
CACHE_ADD("SCP_PROGRAM:STRING=c:/cygwin/bin/scp.exe")

# Now prepare the environment for the VC compiler to actually work
ENV_ADD(PATH "${DOTNET64DIR}/v4.0.30319\;${DOTNETDIR}/v4.0.30319\;${DOTNET64DIR}/v3.5\;${DOTNETDIR}/v3.5\;${VCDIR}/Common 7/IDE\;${VCDIR}/Common7/Tools\;${VCDIR}/VC/Bin/amd64\;${VCDIR}/VC/Bin/VCPackages\;${SDKDIR}/Bin/NETFX 4.0 Tools/x64\;${SDKDIR}/Bin/x64\;${SDKDIR}/Bin\;C:/Windows/system32\;C:/Windows\;C:/Windows/System32/Wbem\;C:/Windows/System32/WindowsPowerShell/v1.0/\;C:/cygwin/bin\;C:/Program Files(x86)/CMake 2.6/bin")
ENV_ADD(INCLUDE "${VCDIR}/VC/INCLUDE\;${SDKDIR}/INCLUDE\;${SDKDIR}/INCLUDE/gl\;")
ENV_ADD(LIB "${VCDIR}/VC/Lib/amd64\;${SDKDIR}/Lib/X64\;")
ENV_ADD(LIBPATH "${DOTNET64DIR}/v4.0.30319\;${DOTNETDIR}/v4.0.30319\;${DOTNET64DIR}/v3.5\;${DOTNETDIR}/v3.5\;${VCDIR}/VC/Lib/amd64\;")
ENV_ADD(WindowsSDKDir "${SDKDIR}")
ENV_ADD(CURRENT_CPU "x64")
ENV_ADD(TARGET_CPU "x64")
ENV_ADD(TARGET_PLATFORM "WIN7")
ENV_ADD(ToolsVersion "4.0")
ENV_ADD(Configuration "Release")
ENV_ADD(PlatformToolset "Windows7.1SDK")
ENV_ADD(CL "/AI C:/Windows/Microsoft.NET/Framework64/v4.0.30319")
ENV_ADD(FrameworkVersion "v4.0.30319")
ENV_ADD(sdkdir "C:/Program Files/Microsoft SDKs/Windows/v7.1/")

