#!/bin/bash
# usage: ./download-for-sfm.sh s3-bucket s3-project-key
aws s3 sync s3://$1/$2 /data/$2 --exclude "*tiles*" --exclude "*reports*" --exclude "*videos*" --exclude "*.360"

