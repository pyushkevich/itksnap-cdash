#!/bin/bash

function usage()
{
  echo "build.sh: ITK-SNAP and friends super-build script"
  echo "usage:"
  echo "  build.sh [options] site_name"
  echo "options:"
  echo "  -e              Perform experimental build, not nightly"
  echo "  -c              Perform continuous build, not nightly"
  echo "  -f              Perform build/test on continuous build even if no update"
  echo "  -p reg_exp      Build products/branches matching regular expression"
  echo "  -C string       Build specific config or config list"
  echo "  -x              Do not build external products (ITK, VTK)"
  echo "  -K              Force clean build (delete build directories)"
  echo "  -T              Skip the test step (only configure/build/package)"
}

# Which model to build
MODEL=Nightly
PRODUCT_MASK=
SKIP_EXTERNAL=
FORCE_CLEAN=
FORCE_CONTINUOUS=
SKIP_TESTING=

# Parse options
while getopts ":ecfKTp:C:hx" opt; do
  case $opt in
    e)
      MODEL=Experimental
      ;;
    c)
      MODEL=Continuous
      ;;
    p)
      PRODUCT_MASK="$OPTARG"
      ;;
    C)
      CUSTOM_CONFIG_LIST="$OPTARG"
      ;;
    h)
      usage
      exit
      ;;
    x)
      SKIP_EXTERNAL=TRUE
      ;;
    f)
      FORCE_CONTINUOUS=TRUE
      ;;
    K)
      FORCE_CLEAN=TRUE
      ;;
    T)
      SKIP_TESTING=TRUE
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
  esac
done

# Get rid of options
shift $(($OPTIND-1))

# Make sure a machine was specified
SITE=$1
SITESCRIPT="./cdash/sites/$SITE/vars.sh"

# Check the location
if [[ ! $SITE ]]; then
  echo "Site must be specified as parameter to this script!" >&2
  exit -1
elif [[ ! -f ./cdash/build_robot.cmake ]]; then
  echo "You seem to be running this script in the wrong directory" >&2
  exit -1
elif [[ ! -f $SITESCRIPT ]]; then
  echo "The script $SITESCRIPT does not exist for site $SITE" >&2
  exit -1
fi

# Announce what we are doing
echo "Building model $MODEL at site ${1?}"

# Read the global script
source $SITESCRIPT

# Override config list
if [[ $CUSTOM_CONFIG_LIST ]]; then
  CONFIG_LIST="$CUSTOM_CONFIG_LIST"
fi

# Update the CDASH repository automatically
pushd cdash
$GIT_BINARY pull
rc=$?
popd 

# If error, done
if [[ $rc -ne 0 ]]; then
  echo "Exiting because git pull failed. Fix manually!" >&2
  exit -1
fi

# Execute the build script
$CMAKE_BINARY_PATH/ctest -V \
  -D PRODUCT_MASK:STRING="${PRODUCT_MASK}" \
  -D SKIP_EXTERNAL:BOOL=${SKIP_EXTERNAL} \
  -D FORCE_CLEAN:BOOL=${FORCE_CLEAN} \
  -D SKIP_TESTING:BOOL=${SKIP_TESTING} \
  -D FORCE_CONTINUOUS:BOOL=${FORCE_CONTINUOUS} \
  -D GIT_BINARY:STRING="${GIT_BINARY}" \
  -D GIT_UID:STRING="${GIT_UID}" \
  -D CONFIG_LIST:STRING="${CONFIG_LIST}" \
  -D CMAKE_BINARY_PATH:PATH="${CMAKE_BINARY_PATH}" \
  -D IN_GLOBAL_MODEL:STRING=$MODEL \
  -D IN_SITE:STRING=$SITE \
  -S ./cdash/build_robot.cmake
