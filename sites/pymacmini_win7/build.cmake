#############################################
# Site-Specific Build Configuration Script  #
#############################################
#
# This script should be edited for each new site where
# we want to build ITK-SNAP and related tools. The
# general structure of this script should be followed on
# all sites, but some additonal variables (e.g., CTEST_ENVIRONMENT)
# may need to be set on some platforms and configurations

# This site uploads all of its builds
SET(DO_UPLOAD ON)

# Library directory: path where all the libraries are build (this is only used internally)
SET(TKDIR "C:/Users/picsl/tk")

# Depending on the configuration, set the library paths for this machine
# as well as some other settings
IF(${IN_CONFIG} MATCHES vce64rel)

  # This configuration is for VISUAL STUDIO EXPRESS 13, 64 bit mode

  # This compiler cannot handle old VTK versions
  SETCOND(SKIP_BUILD ON PRODUCT itk BRANCH v4.2.1)
  SETCOND(SKIP_BUILD ON PRODUCT vtk BRANCH v5.8.0)
  
  # These environment commands were generated using a script 
  ENV_ADD(CommandPromptType "Cross")
  ENV_ADD(DevEnvDir "C:/Program Files (x86)/Microsoft Visual Studio 12.0/Common7/IDE/")
  ENV_ADD(ExtensionSdkDir "C:/Program Files (x86)/Microsoft SDKs/Windows/v8.1/ExtensionSDKs")
  ENV_ADD(Framework40Version "v4.0")
  ENV_ADD(FrameworkDir "C:/Windows/Microsoft.NET/Framework/")
  ENV_ADD(FrameworkDIR32 "C:/Windows/Microsoft.NET/Framework/")
  ENV_ADD(FrameworkDIR64 "C:/Windows/Microsoft.NET/Framework64")
  ENV_ADD(FrameworkVersion "v4.0.30319")
  ENV_ADD(FrameworkVersion32 "v4.0.30319")
  ENV_ADD(FrameworkVersion64 "v4.0.30319")
  ENV_ADD(INCLUDE "C:/Program Files (x86)/Microsoft Visual Studio 12.0/VC/INCLUDE;C:/Program Files (x86)/Windows Kits/8.1/include/shared;C:/Program Files (x86)/Windows Kits/8.1/include/um;C:/Program Files (x86)/Windows Kits/8.1/include/winrt;")
  ENV_ADD(LIB "C:/Program Files (x86)/Microsoft Visual Studio 12.0/VC/LIB/amd64;C:/Program Files (x86)/Windows Kits/8.1/lib/winv6.3/um/x64;")
  ENV_ADD(LIBPATH "C:/Windows/Microsoft.NET/Framework/v4.0.30319;C:/Program Files (x86)/Microsoft Visual Studio 12.0/VC/LIB/amd64;C:/Program Files (x86)/Windows Kits/8.1/References/CommonConfiguration/Neutral;C:/Program Files (x86)/Microsoft SDKs/Windows/v8.1/ExtensionSDKs/Microsoft.VCLibs/12.0/References/CommonConfiguration/neutral;")
  ENV_ADD(PATH "C:/Program Files (x86)/Microsoft Visual Studio 12.0/Common7/IDE/CommonExtensions/Microsoft/TestWindow;C:/Program Files (x86)/MSBuild/12.0/bin;C:/Program Files (x86)/MSBuild/12.0/bin;C:/Program Files (x86)/Microsoft Visual Studio 12.0/Common7/IDE/;C:/Program Files (x86)/Microsoft Visual Studio 12.0/VC/BIN/x86_amd64;C:/Program Files (x86)/Microsoft Visual Studio 12.0/VC/BIN;C:/Program Files (x86)/Microsoft Visual Studio 12.0/Common7/Tools;C:/Windows/Microsoft.NET/Framework/v4.0.30319;C:/Program Files (x86)/Microsoft Visual Studio 12.0/VC/VCPackages;C:/Program Files (x86)/Microsoft Visual Studio 12.0/Team Tools/Performance Tools;C:/Program Files (x86)/Windows Kits/8.1/bin/x86;C:/Program Files (x86)/Microsoft SDKs/Windows/v8.1A/bin/NETFX 4.5.1 Tools/x64/;C:/cygwin/usr/local/bin;C:/cygwin/bin;C:/Users/picsl/tk/Qt/bin64/qt-everywhere-opensource-src-4.8.2/bin;C:/Windows/system32;C:/Windows;C:/Windows/System32/Wbem;C:/Windows/System32/WindowsPowerShell/v1.0;C:/Program Files/Microsoft Windows Performance Toolkit;C:/Program Files (x86)/CMake 2.8/bin;C:/Program Files (x86)/c3d-1.0.0/bin;C:/Program Files/Microsoft SQL Server/110/Tools/Binn;C:/Program Files (x86)/Microsoft SDKs/TypeScript/1.0;C:/Program Files (x86)/CMake 2.6/bin;C:/cygwin/lib/lapack")
  ENV_ADD(Platform "x64")
  ENV_ADD(VCINSTALLDIR "C:/Program Files (x86)/Microsoft Visual Studio 12.0/VC/")
  ENV_ADD(VisualStudioVersion "12.0")
  ENV_ADD(VSINSTALLDIR "C:/Program Files (x86)/Microsoft Visual Studio 12.0/")
  ENV_ADD(WindowsSdkDir "C:/Program Files (x86)/Windows Kits/8.1/")
  ENV_ADD(WindowsSDK_ExecutablePath_x64 "C:/Program Files (x86)/Microsoft SDKs/Windows/v8.1A/bin/NETFX 4.5.1 Tools/x64/")
  ENV_ADD(WindowsSDK_ExecutablePath_x86 "C:/Program Files (x86)/Microsoft SDKs/Windows/v8.1A/bin/NETFX 4.5.1 Tools/")
  
  SET(MYBIN "bin32")
  SET(VCVER "vce13")
  SET(VCBINDIR "C:/Program Files (x86)/Microsoft Visual Studio 12.0/VC/bin")
  SET(VCBINDIR64 "C:/Program Files (x86)/Microsoft Visual Studio 12.0/VC/bin/x86_amd64")
  SET(SDKBINDIR "C:/Program Files (x86)/Windows Kits/8.1/bin/x86")

  # These cache entries are configuration specific. I ran cmake gui from the VC prompt with Nmake as the 
  # build system to generate these
  
  # Add JOM to the path
  ENV_ADD(PATH "${TKDIR}/jom_1_0_16;$ENV{PATH}")
  
  #CACHE_ADD("CMAKE_MAKE_PROGRAM:FILEPATH=${VCBINDIR}/nmake.exe")
  CACHE_ADD("CMAKE_MAKE_PROGRAM:FILEPATH=${TKDIR}/jom_1_0_16/jom.exe")
  CACHE_ADD("CMAKE_C_COMPILER:FILEPATH=${VCBINDIR64}/cl.exe")
  CACHE_ADD("CMAKE_C_FLAGS:STRING= /DWIN32 /D_WINDOWS /W3 /Zm1000 /D_CRT_SECURE_NO_WARNINGS /wd4250")
  CACHE_ADD("CMAKE_CXX_COMPILER:FILEPATH=${VCBINDIR64}/cl.exe")
  CACHE_ADD("CMAKE_CXX_FLAGS:STRING= /DWIN32 /D_WINDOWS /W3 /Zm1000 /EHsc /GR /D_CRT_SECURE_NO_WARNINGS /wd4250")
  CACHE_ADD("CMAKE_RC_COMPILER:FILEPATH=${SDKBINDIR}/RC.Exe")
  CACHE_ADD("VCREDIST_EXE:FILEPATH=C:/Users/picsl/tk/redist/msvc_express_2013/vcredist_x64.exe")

ELSEIF(${IN_CONFIG} MATCHES vce32rel)

  # Directory shortcuts
  SET(VCDIR "C:/Program Files (x86)/Microsoft Visual Studio 10.0")
  SET(SDKDIR "C:/Program Files/Microsoft SDKs/Windows/v7.1")
  SET(DOTNETDIR "C:/WINDOWS/Microsoft.NET/Framework")
  SET(CMAKEDIR "C:/Program Files (x86)/CMake 2.8")

  SET(MYBIN "bin32")
  SET(VCBINDIR "${VCDIR}/VC/Bin")
  SET(SDKBINDIR "${SDKDIR}/bin")
  SET(WINSUFFIX "x86")

  SET(VCVER "vce10")

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

  # Add JOM to the path
  ENV_ADD(PATH "${TKDIR}/jom_1_0_16;$ENV{PATH}")
  
  # Put the redistributable
  CACHE_ADD("CMAKE_MAKE_PROGRAM:FILEPATH=${TKDIR}/jom_1_0_16/jom.exe")
  CACHE_ADD("CMAKE_C_COMPILER:FILEPATH=${VCBINDIR}/cl.exe")
  CACHE_ADD("CMAKE_C_FLAGS:STRING= /DWIN32 /D_WINDOWS /W3 /Zm1000 /D_CRT_SECURE_NO_WARNINGS /wd4250")
  CACHE_ADD("CMAKE_CXX_COMPILER:FILEPATH=${VCBINDIR}/cl.exe")
  CACHE_ADD("CMAKE_CXX_FLAGS:STRING= /DWIN32 /D_WINDOWS /W3 /Zm1000 /EHsc /GR /D_CRT_SECURE_NO_WARNINGS /wd4250")
  CACHE_ADD("CMAKE_RC_COMPILER:FILEPATH=${SDKBINDIR}/RC.Exe")
  CACHE_ADD("VCREDIST_EXE:FILEPATH=${SDKDIR}/Redist/VC/vcredist_${WINSUFFIX}.exe")

ELSE(${IN_CONFIG} MATCHES vce64rel)
  
  MESSAGE(FATAL_ERROR "Unknown configuration ${IN_CONFIG}")

ENDIF(${IN_CONFIG} MATCHES vce64rel)

# Set the Generator
SET(CTEST_CMAKE_GENERATOR "NMake Makefiles JOM")

# Add cache entries
CACHE_ADD("MAKECOMMAND:STRING=jom.exe -i -j 4")
CACHE_ADD("BUILDNAME:STRING=Win7-${VCVER}-${IN_CONFIG}")
CACHE_ADD("SITE:STRING=paulyimac_win7")
CACHE_ADD("CMAKE_BUILD_TYPE:STRING=Release")
CACHE_ADD("SCP_PROGRAM:STRING=c:/cygwin/bin/scp.exe")


# Add product-specific cache entries
IF(NEED_FLTK)
  CACHE_ADD("SNAP_USE_FLTK_PNG:BOOL=ON")
  CACHE_ADD("SNAP_USE_FLTK_JPEG:BOOL=ON")
  CACHE_ADD("SNAP_USE_FLTK_ZLIB:BOOL=ON")
  CACHE_ADD("FLTK_BASE_LIBRARY:FILEPATH=C:/Users/picsl/tk/fltk13/install-${MYBIN}/lib/fltk.lib")
ENDIF(NEED_FLTK)

IF(NEED_QT4)
  CACHE_ADD("QT_QMAKE_EXECUTABLE:FILEPATH=${TKDIR}/Qt/${MYBIN}/qt-everywhere-opensource-src-4.8.2/bin/qmake.exe")
ENDIF(NEED_QT4)

IF(NEED_QT5)
  # Currently there is no way to build 64 bit using Qt5
  SETCOND(QT5_PATH "C:/Qt5/5.3/msvc2013_64_opengl/lib/cmake" CONFIG vce64rel)
  SETCOND(QT5_PATH "C:/Qt5/5.3/msvc2010_opengl/lib/cmake" CONFIG vce32rel)
  CACHE_ADD("CMAKE_PREFIX_PATH:FILEPATH=${QT5_PATH}")
  #ENV_ADD(PATH "${QT5_PATH}/bin\;$ENV{PATH}")
ENDIF(NEED_QT5)
  
IF(NEED_QT54)
  SETCOND(QT5_PATH "C:/Qt54/5.4/msvc2013_64/lib/cmake" CONFIG vce64rel)
  SETCOND(QT5_PATH "C:/Qt54/5.4/msvc2010_opengl/lib/cmake" CONFIG vce32rel)
  CACHE_ADD("CMAKE_PREFIX_PATH:FILEPATH=${QT5_PATH}")
ENDIF(NEED_QT54)

# C3D specific settings
CACHE_ADD("BUILD_GUI:BOOLEAN=ON" PRODUCT "c3d")

