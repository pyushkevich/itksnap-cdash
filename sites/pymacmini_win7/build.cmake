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
  ENV_ADD(Configuration "Release")
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
CACHE_ADD("CMAKE_C_FLAGS:STRING= /DWIN32 /D_WINDOWS /W3 /Zm1000 /D_CRT_SECURE_NO_WARNINGS /wd4250")
CACHE_ADD("CMAKE_CXX_COMPILER:FILEPATH=${VCBINDIR}/cl.exe")
CACHE_ADD("CMAKE_CXX_FLAGS:STRING= /DWIN32 /D_WINDOWS /W3 /Zm1000 /EHsc /GR /D_CRT_SECURE_NO_WARNINGS /wd4250")
CACHE_ADD("CMAKE_RC_COMPILER:FILEPATH=${SDKBINDIR}/RC.Exe")
CACHE_ADD("BUILDNAME:STRING=Win7-vce10-${IN_CONFIG}")
CACHE_ADD("SITE:STRING=paulyimac_win7")
CACHE_ADD("CMAKE_BUILD_TYPE:STRING=Release")
CACHE_ADD("VCREDIST_EXE:FILEPATH=${SDKDIR}/Redist/VC/vcredist_${WINSUFFIX}.exe")
CACHE_ADD("SCP_PROGRAM:STRING=c:/cygwin/bin/scp.exe")

# Library directory: path where all the libraries are build (this is only used internally)
SET(TKDIR "C:/Users/picsl/tk")

# Add product-specific cache entries
IF(NEED_FLTK)
  CACHE_ADD("SNAP_USE_FLTK_PNG:BOOL=ON")
  CACHE_ADD("SNAP_USE_FLTK_JPEG:BOOL=ON")
  CACHE_ADD("SNAP_USE_FLTK_ZLIB:BOOL=ON")
  CACHE_ADD("FLTK_BASE_LIBRARY:FILEPATH=C:/Users/picsl/tk/fltk13/install-${MYBIN}/lib/fltk.lib")
ENDIF(NEED_FLTK)

IF(NEED_QT4)
  CACHE_ADD("QT_QMAKE_EXECUTABLE:FILEPATH=${TKDIR}/Qt/${MYBIN}/qt-everywhere-opensource-src-4.8.2/bin/qmake.exe" PRODUCT itksnap BRANCH qtsnap)
ENDIF(NEED_QT4)

IF(NEED_QT5)
  # Currently there is no way to build 64 bit using Qt5
  SETCOND(SKIP_BUILD ON CONFIG vce64rel)
  SETCOND(QT5_PATH "C:/Qt5/5.3/msvc2013_64_opengl/lib/cmake" CONFIG vce64rel)
  SETCOND(QT5_PATH "C:/Qt5/5.3/msvc2010_opengl/lib/cmake" CONFIG vce32rel)
  CACHE_ADD("CMAKE_PREFIX_PATH:FILEPATH=${QT5_PATH}")
  #ENV_ADD(PATH "${QT5_PATH}/bin\;$ENV{PATH}")
ENDIF(NEED_QT5)
  
# C3D specific settings
CACHE_ADD("BUILD_GUI:BOOLEAN=ON" PRODUCT "c3d")

