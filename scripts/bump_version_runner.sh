#!/bin/bash

# Check if VERSION-RUNNERS file exists
if [ ! -f VERSION-RUNNERS ]; then
  echo "2.1.40" > VERSION-RUNNERS
fi

current_version=$(cat VERSION-RUNNERS)

IFS='.' read -r -a version_parts <<< "$current_version"
version_parts[2]=$((version_parts[2] + 1))
new_version="${version_parts[0]}.${version_parts[1]}.${version_parts[2]}"

# Write the new version back to the VERSION-RUNNERS file
echo $new_version > VERSION-RUNNERS

echo $new_version