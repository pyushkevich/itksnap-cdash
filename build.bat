@echo off
set MODEL=Nightly
set PRODUCT_MASK=
set SKIP_EXTERNAL=
set FORCE_CLEAN=
set FORCE_CONTINUOUS=
set SKIP_TESTING=

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

IF "%1"=="-c" (
  set MODEL=Continuous
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
  echo "  -c              Perform continuous build, not nightly"
  echo "  -f              Perform build/test on continuous build even if no update"
  echo "  -p reg_exp      Build products/branches matching regular expression"
  echo "  -x              Do not build external products (ITK, VTK)"
  echo "  -K              Force clean build (delete build directories)"
  echo "  -T              Skip the test step (only configure/build/package)"
  SHIFT
  GOTO :end
  GOTO :loop
)

IF "%1"=="-x" (
  set SKIP_EXTERNAL=TRUE
  SHIFT
  GOTO :loop
)

IF "%1"=="-f" (
  set FORCE_CONTINUOUS=TRUE
  SHIFT
  GOTO :loop
)

IF "%1"=="-K" (
  set FORCE_CLEAN=TRUE
  SHIFT
  GOTO :loop
)

IF "%1"=="-K" (
  set SKIP_TESTING=TRUE
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
  -D FORCE_CLEAN:BOOL=%FORCE_CLEAN% ^
  -D SKIP_TESTING:BOOL=%SKIP_TESTING% ^
  -D FORCE_CONTINUOUS:BOOL=%FORCE_CONTINUOUS% ^
  -D GIT_BINARY:STRING="%GIT_BINARY%" ^
  -D GIT_UID:STRING="%GIT_UID%" ^
  -D CONFIG_LIST:STRING="%CONFIG_LIST%" ^
  -D CMAKE_BINARY_PATH:PATH="%CMAKE_BINARY_PATH%" ^
  -D IN_GLOBAL_MODEL:STRING=%MODEL% ^
  -D IN_SITE:STRING=%SITE% ^
  -S cdash\build_robot.cmake


:end
