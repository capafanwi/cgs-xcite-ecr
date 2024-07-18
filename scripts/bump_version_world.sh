#!/bin/bash

# Check if VERSION file exists
if [ ! -f VERSION-WORLD ]; then
  echo "2.1.2" > VERSION-WORLD
fi

current_version=$(cat VERSION-WORLD)

IFS='.' read -r -a version_parts <<< "$current_version"
version_parts[2]=$((version_parts[2] + 1))
new_version="${version_parts[0]}.${version_parts[1]}.${version_parts[2]}"

# Write the new version back to the VERSION file
echo $new_version > VERSION-WORLD

echo $new_version