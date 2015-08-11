#!/bin/bash

# If no parameters print help
if [[ $# -lt 2 ]]; then
  echo "This script generates CMAKE script from Windows MSVC environment"
  echo "Call it as follows:"
  echo "$0 \"C:\\\\Program Files (x86)\\\\Microsoft Visual Studio 12.0\\\\VC\\\\vcvarsall.bat\" x86_amd64"
  exit
fi

# Read the environment
cmd.exe /c "\"${1?}\" ${2?} & set" > /tmp/env.txt

#cmd.exe /c "\"C:\\Program Files (x86)\\Microsoft Visual Studio 12.0\\VC\\vcvarsall.bat\" x86_amd64 & set" > /tmp/env.txt

# Read the plain environment
cmd.exe /c "set" > /tmp/plain.txt

# Use diff to get a list of paths to override
COMP=$(diff /tmp/env.txt /tmp/plain.txt | grep '^< ' | sed -e "s/=.*//g" -e "s/^< //")

# Parse the relevant line
for key in ${COMP[*]}; do

  # Read the line
  line=$(grep "^${key}=" /tmp/env.txt)

  # Remove first part, replace slashes with forward
  sline=$(echo $line | sed -e "s/^${key}=//g" | sed -e "s/\\\\/\\//g")

  # Write the CMake line
  echo "ENV_ADD($key \"$sline\")"

done
