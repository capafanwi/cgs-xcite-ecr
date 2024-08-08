#!/bin/bash
# Usage: ./create-projects-with-grid.sh grid.csv data-dir s3-project-key/project-template-directory project-template.json s3-bucket

# Read the header row into an array
IFS=',' read -r -a headers < "$1"

# Extract the root name of the csv file to be a parent directory for the tiled projects
# This prevents different csv grids from conflicting
filename=$(basename "$1")
csvname="${filename%.*}"

# Loop through the rest of the file
while read -r line; do
  # Split the line into fields
  IFS=',' read -r -a fields <<< "$line"

  # Ignore blank lines
  [ -z "$line" ] && continue

  # Loop through the fields and assign them to variables
  for (( i=0; i<${#fields[@]}; i++ )); do
    # Replace spaces with underscores in the header name (not really necessary for this file)
    header=$(echo "${headers[$i]}" | tr ' ' '_')
    # Assign the field to a variable with the header name
    declare "$header=${fields[$i]}"
  done

  # Store the NUMPOINTS value in a separate variable
  num_points="${fields[-1]}"
  num_points_int=${num_points%.*}
  margin=0.0003

  bounds="\"bounds\": { \"blLat\": "$(echo $bottom'-'$margin | bc -l)", \"blLong\":"$(echo $left'-'$margin | bc -l)", \"trLat\": "$(echo $top'+'$margin | bc -l)", \"trLong\":"$(echo $right'+'$margin | bc -l)"}"

  if [ $num_points_int -gt 0 ]; then
    # Shows which line we're processing (debugging)
    echo $line

    # This is the real work
    mkdir -p $2/$3/$csvname/$name/videos
    # Create the project file
    sed 's^"bounds": null^'"${bounds}"'^' $2/$3/$4 | sed 's^projectName^'"${name}"'^' | sed 's^projectDir^'"${name}"'^' > $2/$3/$csvname/$name/project.json

    # Copy the contents of the videos (one thread each video)
    aws s3 sync s3://$5/$3/videos s3://$5/$3/$csvname/$name/videos
    #cp -r $2/$3/videos $2/$3/$csvname/$name/
  fi
done < <(tail -n +2 "$1")  # Skip the header row
