#!/bin/bash

function usage()
{
  echo "build.sh: ITK-SNAP and friends super-build script"
  echo "usage:"
  echo "  build.sh [options] site_name"
  echo "options:"
  echo "  -e              Perform experimental build, not nightly"
  echo "  -p reg_exp      Build products/branches matching regular expression"
  echo "  -x              Do not build external products (ITK, VTK)"
}

# Which model to build
MODEL=Nightly
PRODUCT_MASK=
SKIP_EXTERNAL=

# Parse options
while getopts ":ep:hx" opt; do
  case $opt in
    e)
      MODEL=Experimental
      ;;
    p)
      PRODUCT_MASK="$OPTARG"
      ;;
    h)
      usage
      exit
      ;;
    x)
      SKIP_EXTERNAL=TRUE
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
  -D GIT_BINARY:STRING="${GIT_BINARY}" \
  -D GIT_UID:STRING="${GIT_UID}" \
  -D CONFIG_LIST:STRING="${CONFIG_LIST}" \
  -D CMAKE_BINARY_PATH:PATH="${CMAKE_BINARY_PATH}" \
  -D IN_GLOBAL_MODEL:STRING=$MODEL \
  -D IN_SITE:STRING=$SITE \
  -S ./cdash/build_robot.cmake
