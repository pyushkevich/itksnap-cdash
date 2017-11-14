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
SET(TKDIR "E:/tk")

# Where all the curl libraries are built
SET(CURLROOT "E:/tk/libcurl/curl-7.56.1/builds")

# Set SNAP test acceleration factor
CACHE_ADD("SNAP_GUI_TEST_ACCEL:STRING=1.0" PRODUCT itksnap)

# Depending on the configuration, set the library paths for this machine
# as well as some other settings
IF(${IN_CONFIG} MATCHES vce64.*)

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
  ENV_ADD(PATH "C:/Program Files (x86)/Microsoft Visual Studio 12.0/Common7/IDE/CommonExtensions/Microsoft/TestWindow;C:/Program Files (x86)/MSBuild/12.0/bin;C:/Program Files (x86)/MSBuild/12.0/bin;C:/Program Files (x86)/Microsoft Visual Studio 12.0/Common7/IDE/;C:/Program Files (x86)/Microsoft Visual Studio 12.0/VC/BIN/x86_amd64;C:/Program Files (x86)/Microsoft Visual Studio 12.0/VC/BIN;C:/Program Files (x86)/Microsoft Visual Studio 12.0/Common7/Tools;C:/Windows/Microsoft.NET/Framework/v4.0.30319;C:/Program Files (x86)/Microsoft Visual Studio 12.0/VC/VCPackages;C:/Program Files (x86)/Microsoft Visual Studio 12.0/Team Tools/Performance Tools;C:/Program Files (x86)/Windows Kits/8.1/bin/x86;C:/Program Files (x86)/Microsoft SDKs/Windows/v8.1A/bin/NETFX 4.5.1 Tools/x64/;c:/Users/paul/bin;.;C:/Program Files (x86)/Git/local/bin;C:/Program Files (x86)/Git/mingw/bin;C:/Program Files (x86)/Git/bin;c:/Windows/system32;c:/Windows;c:/Windows/System32/Wbem;c:/Windows/System32/WindowsPowerShell/v1.0/;c:/Program Files/Microsoft SQL Server/110/Tools/Binn/;c:/Program Files (x86)/Microsoft SDKs/TypeScript/1.0/;c:/Program Files/Microsoft SQL Server/120/Tools/Binn/")
  ENV_ADD(Platform "x64")
  ENV_ADD(VCINSTALLDIR "C:/Program Files (x86)/Microsoft Visual Studio 12.0/VC/")
  ENV_ADD(VisualStudioVersion "12.0")
  ENV_ADD(VSINSTALLDIR "C:/Program Files (x86)/Microsoft Visual Studio 12.0/")
  ENV_ADD(WindowsSdkDir "C:/Program Files (x86)/Windows Kits/8.1/")
  ENV_ADD(WindowsSDK_ExecutablePath_x64 "C:/Program Files (x86)/Microsoft SDKs/Windows/v8.1A/bin/NETFX 4.5.1 Tools/x64/")
  ENV_ADD(WindowsSDK_ExecutablePath_x86 "C:/Program Files (x86)/Microsoft SDKs/Windows/v8.1A/bin/NETFX 4.5.1 Tools/")
    
  # Directory shortcuts
  SET(MYBIN "bin64")
  SET(VCVER "vce13")
  SET(VCBINDIR "C:/Program Files (x86)/Microsoft Visual Studio 12.0/VC/bin")
  SET(VCBINDIR64 "C:/Program Files (x86)/Microsoft Visual Studio 12.0/VC/bin/x86_amd64")
  SET(SDKBINDIR "C:/Program Files (x86)/Windows Kits/8.1/bin/x86")

  # These cache entries are configuration specific. I ran cmake gui from the VC prompt with Nmake as the 
  # build system to generate these
  CACHE_ADD("CMAKE_C_COMPILER:FILEPATH=${VCBINDIR64}/cl.exe")
  CACHE_ADD("CMAKE_CXX_COMPILER:FILEPATH=${VCBINDIR64}/cl.exe")
  CACHE_ADD("VCREDIST_EXE:FILEPATH=${TKDIR}/redist/msvc_express_2013/vcredist_x64.exe")

  # Curl directory
  SETCOND(CURLDIR "${CURLROOT}/libcurl-vc12-x64-release-static-ipv6-sspi-winssl" CONFIG .*rel.*)
  SETCOND(CURLDIR "${CURLROOT}/libcurl-vc12-x64-debug-static-ipv6-sspi-winssl" CONFIG .*dbg.*)
  CACHE_ADD("CURL_LIBRARY:FILEPATH=${CURLDIR}/lib/libcurl_a.lib" PRODUCT itksnap CONFIG .*rel.*)
  CACHE_ADD("CURL_LIBRARY:FILEPATH=${CURLDIR}/lib/libcurl_a_debug.lib" PRODUCT itksnap CONFIG .*dbg.*)
  CACHE_ADD("CURL_INCLUDE_DIR:PATH=${CURLDIR}/include" PRODUCT itksnap)

ELSEIF(${IN_CONFIG} MATCHES vce32.*)

  # This configuration is for VISUAL STUDIO EXPRESS 13, 64 bit mode

  # This compiler cannot handle old VTK versions
  SETCOND(SKIP_BUILD ON PRODUCT itk BRANCH v4.2.1)
  SETCOND(SKIP_BUILD ON PRODUCT vtk BRANCH v5.8.0)
  
  # Generated by a script
  ENV_ADD(DevEnvDir "C:/Program Files (x86)/Microsoft Visual Studio 12.0/Common7/IDE/")
  ENV_ADD(ExtensionSdkDir "C:/Program Files (x86)/Microsoft SDKs/Windows/v8.1/ExtensionSDKs")
  ENV_ADD(Framework40Version "v4.0")
  ENV_ADD(FrameworkDir "C:/Windows/Microsoft.NET/Framework/")
  ENV_ADD(FrameworkDIR32 "C:/Windows/Microsoft.NET/Framework/")
  ENV_ADD(FrameworkVersion "v4.0.30319")
  ENV_ADD(FrameworkVersion32 "v4.0.30319")
  ENV_ADD(INCLUDE "C:/Program Files (x86)/Microsoft Visual Studio 12.0/VC/INCLUDE;C:/Program Files (x86)/Windows Kits/8.1/include/shared;C:/Program Files (x86)/Windows Kits/8.1/include/um;C:/Program Files (x86)/Windows Kits/8.1/include/winrt;")
  ENV_ADD(LIB "C:/Program Files (x86)/Microsoft Visual Studio 12.0/VC/LIB;C:/Program Files (x86)/Windows Kits/8.1/lib/winv6.3/um/x86;")
  ENV_ADD(LIBPATH "C:/Windows/Microsoft.NET/Framework/v4.0.30319;C:/Program Files (x86)/Microsoft Visual Studio 12.0/VC/LIB;C:/Program Files (x86)/Windows Kits/8.1/References/CommonConfiguration/Neutral;C:/Program Files (x86)/Microsoft SDKs/Windows/v8.1/ExtensionSDKs/Microsoft.VCLibs/12.0/References/CommonConfiguration/neutral;")
  ENV_ADD(PATH "C:/Program Files (x86)/Microsoft Visual Studio 12.0/Common7/IDE/CommonExtensions/Microsoft/TestWindow;C:/Program Files (x86)/MSBuild/12.0/bin;C:/Program Files (x86)/MSBuild/12.0/bin;C:/Program Files (x86)/Microsoft Visual Studio 12.0/Common7/IDE/;C:/Program Files (x86)/Microsoft Visual Studio 12.0/VC/BIN;C:/Program Files (x86)/Microsoft Visual Studio 12.0/Common7/Tools;C:/Windows/Microsoft.NET/Framework/v4.0.30319;C:/Program Files (x86)/Microsoft Visual Studio 12.0/VC/VCPackages;C:/Program Files (x86)/Microsoft Visual Studio 12.0/Team Tools/Performance Tools;C:/Program Files (x86)/Windows Kits/8.1/bin/x86;C:/Program Files (x86)/Microsoft SDKs/Windows/v8.1A/bin/NETFX 4.5.1 Tools/;c:/Users/paul/bin;.;C:/Program Files (x86)/Git/local/bin;C:/Program Files (x86)/Git/mingw/bin;C:/Program Files (x86)/Git/bin;c:/Windows/system32;c:/Windows;c:/Windows/System32/Wbem;c:/Windows/System32/WindowsPowerShell/v1.0/;c:/Program Files/Microsoft SQL Server/110/Tools/Binn/;c:/Program Files (x86)/Microsoft SDKs/TypeScript/1.0/;c:/Program Files/Microsoft SQL Server/120/Tools/Binn/")
  ENV_ADD(VCINSTALLDIR "C:/Program Files (x86)/Microsoft Visual Studio 12.0/VC/")
  ENV_ADD(VisualStudioVersion "12.0")
  ENV_ADD(VSINSTALLDIR "C:/Program Files (x86)/Microsoft Visual Studio 12.0/")
  ENV_ADD(WindowsSdkDir "C:/Program Files (x86)/Windows Kits/8.1/")
  ENV_ADD(WindowsSDK_ExecutablePath_x64 "C:/Program Files (x86)/Microsoft SDKs/Windows/v8.1A/bin/NETFX 4.5.1 Tools/x64/")
  ENV_ADD(WindowsSDK_ExecutablePath_x86 "C:/Program Files (x86)/Microsoft SDKs/Windows/v8.1A/bin/NETFX 4.5.1 Tools/")

  # Directory shortcuts
  SET(MYBIN "bin32")
  SET(VCVER "vce13")
  SET(VCBINDIR "C:/Program Files (x86)/Microsoft Visual Studio 12.0/VC/bin")
  SET(VCBINDIR64 "C:/Program Files (x86)/Microsoft Visual Studio 12.0/VC/bin/x86_amd64")
  SET(SDKBINDIR "C:/Program Files (x86)/Windows Kits/8.1/bin/x86")

  # These cache entries are configuration specific. I ran cmake gui from the VC prompt with Nmake as the 
  # build system to generate these
  CACHE_ADD("CMAKE_C_COMPILER:FILEPATH=${VCBINDIR}/cl.exe")
  CACHE_ADD("CMAKE_CXX_COMPILER:FILEPATH=${VCBINDIR}/cl.exe")
  CACHE_ADD("VCREDIST_EXE:FILEPATH=${TKDIR}/redist/msvc_express_2013/vcredist_x86.exe")

ELSE(${IN_CONFIG} MATCHES vce64.*)
  
  MESSAGE(FATAL_ERROR "Unknown configuration ${IN_CONFIG}")

ENDIF(${IN_CONFIG} MATCHES vce64.*)

# Set the Generator
SET(CTEST_CMAKE_GENERATOR "NMake Makefiles JOM")

# Add JOM to the path
ENV_ADD(PATH "${TKDIR}/jom_1_1_2;$ENV{PATH}")

# Add cache entries
CACHE_ADD("CMAKE_MAKE_PROGRAM:FILEPATH=${TKDIR}/jom_1_1_2/jom.exe")
CACHE_ADD("MAKECOMMAND:STRING=jom.exe -i -j 12")
CACHE_ADD("BUILDNAME:STRING=Win7-${VCVER}-${IN_CONFIG}")
CACHE_ADD("SITE:STRING=pyhisto")
CACHE_ADD("CMAKE_BUILD_TYPE:STRING=Release" CONFIG .*rel.*)
CACHE_ADD("CMAKE_BUILD_TYPE:STRING=Debug" CONFIG .*dbg.*)
CACHE_ADD("SCP_PROGRAM:STRING=C:/Program Files/Git/usr/bin/scp.exe")
CACHE_ADD("CMAKE_C_FLAGS:STRING= /DWIN32 /D_WINDOWS /W3 /Zm1000 /D_CRT_SECURE_NO_WARNINGS /wd4250")
CACHE_ADD("CMAKE_CXX_FLAGS:STRING= /DWIN32 /D_WINDOWS /W3 /Zm1000 /EHsc /GR /D_CRT_SECURE_NO_WARNINGS /wd4250")
CACHE_ADD("CMAKE_RC_COMPILER:FILEPATH=${SDKBINDIR}/RC.Exe")

# Add product-specific cache entries

IF(NEED_QT4)
  CACHE_ADD("QT_QMAKE_EXECUTABLE:FILEPATH=E:/tk/Qt48/msvc2013_64/bin/qmake.exe")
ELSEIF(NEED_QT5)
  SETCOND(SKIP_BUILD ON)
ELSEIF(NEED_QT54)
  SETCOND(SKIP_BUILD ON  CONFIG vce32.*)
  SETCOND(QT5_PATH "E:/tk/Qt/5.4/msvc2013_64/lib/cmake" CONFIG vce64.*)
  CACHE_ADD("CMAKE_PREFIX_PATH:FILEPATH=${QT5_PATH}")
ELSEIF(NEED_QT56)
  SETCOND(SKIP_BUILD ON  CONFIG vce32.*)
  SETCOND(QT5_PATH "E:/tk/Qt/5.6/msvc2013_64/lib/cmake" CONFIG vce64.*)
  CACHE_ADD("CMAKE_PREFIX_PATH:FILEPATH=${QT5_PATH}")
ENDIF(NEED_QT4)

# C3D specific settings
CACHE_ADD("BUILD_GUI:BOOLEAN=ON" PRODUCT "c3d")
