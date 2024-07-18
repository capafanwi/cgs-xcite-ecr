#!/bin/bash

# Check if VERSION-OSM file exists
if [ ! -f VERSION-OSM ]; then
  echo "2.1.2" > VERSION-OSM
fi

current_version=$(cat VERSION-OSM)

IFS='.' read -r -a version_parts <<< "$current_version"
version_parts[2]=$((version_parts[2] + 1))
new_version="${version_parts[0]}.${version_parts[1]}.${version_parts[2]}"

# Write the new version back to the VERSION-OSM file
echo $new_version > VERSION-OSM

echo $new_version