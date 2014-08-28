#!/bin/bash

# Which model to build
MODEL=Nightly

# Parse options
while getopts ":e" opt; do
  case $opt in
    e)
      MODEL=Experimental
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
  esac
done

# Get rid of options
shift $(($OPTIND-1))

# Make sure a machine was specified
echo "Building model $MODEL at site ${1?}"

# Update the CDASH repository automatically
pushd cdash
git fetch
popd 

# Execute the build script
ctest -V -S cdash/build_robot.cmake,$1,$MODEL
