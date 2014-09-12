@echo off
set MODEL=Nightly
set PRODUCT_MASK=
set SKIP_EXTERNAL=

@rem set PATH="%ProgramFiles(x86)%/CMake 2.8/bin;%PATH%"
@rem set PATH="%ProgramFiles(x86)%/Git/bin;%PATH%"
@rem 

rem READ OPTIONAL PARAMETERS


:loop

IF "%1"=="-e" (
  set MODEL=Experimental
  SHIFT
  GOTO :loop
)

IF "%1"=="-p" (
  set PRODUCT_MASK=%2
  SHIFT
  SHIFT
  GOTO :loop
)

IF "%1"=="-h" (
  echo "build.bat: ITK-SNAP and friends super-build script"
  echo "usage:"
  echo "  build.bat [options] site_name"
  echo "options:"
  echo "  -e              Perform experimental build, not nightly"
  echo "  -p reg_exp      Build products/branches matching regular expression"
  echo "  -x              Do not build external products (ITK, VTK)"
  SHIFT
  GOTO :end
  GOTO :loop
)

IF "%1"=="-x" (
  set SKIP_EXTERNAL=TRUE
  SHIFT
  GOTO :loop
)

set SITE=%1
set SITESCRIPT="cdash\\sites\\%SITE%\\vars.bat"

rem Check the location
IF "%SITE%"=="" (
  echo "Site must be specified as parameter to this script"
  goto :end
)
IF NOT EXIST cdash\build_robot.cmake (
  echo "You seem to be running this script in the wrong directory"
  goto :end
)
IF NOT EXIST "%SITESCRIPT%" (
  echo "The script %SITESCRIPT% does not exist for site %SITE%"
  goto :end
)

echo "Building model %MODEL% at site %SITE%

CALL "%SITESCRIPT%"

echo Updating the CDASH repo
pushd cdash
"%GIT_BINARY%" pull
popd

"%CMAKE_BINARY_PATH%/ctest.exe" -V ^
  -D PRODUCT_MASK:STRING=%PRODUCT_MASK% ^
  -D SKIP_EXTERNAL:BOOL=%SKIP_EXTERNAL% ^
  -D GIT_BINARY:STRING="%GIT_BINARY%" ^
  -D GIT_UID:STRING="%GIT_UID%" ^
  -D CONFIG_LIST:STRING="%CONFIG_LIST%" ^
  -D CMAKE_BINARY_PATH:PATH="%CMAKE_BINARY_PATH%" ^
  -D IN_GLOBAL_MODEL:STRING=%MODEL% ^
  -D IN_SITE:STRING=%SITE% ^
  -S cdash\build_robot.cmake


:end
