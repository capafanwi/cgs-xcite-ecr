#!/bin/bash 
# Need to have some-sfm-utils and Go installed.
# usage: ./create-samples.sh <project-dir>

PROJECT_NAME=$1
CONFIG_FILE=$2

for dir in ${PROJECT_NAME}/videos/*/
do
    echo $dir
    noslash=${dir%*/}
    filename=${noslash##*/}
    videoname=$filename.360
    echo $videoname
    gopro2gpx $dir/$videoname $dir/metadata
    gpxsimplify -d 2 $dir/metadata.gpx
done


