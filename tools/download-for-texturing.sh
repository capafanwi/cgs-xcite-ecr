#!/bin/bash
# usage: ./download-for-texturing.sh s3-bucket s3-project-key
aws s3 sync s3://$1/$2 /data/$2 --exclude "*" --include "*.nvm" --include "*.ply" --include "*perspective*" --include "*.yaml" --include "*.json" --exclude "*.npz" --exclude "*reports*" --include "*openmvs*" --exclude "*tiles*" --exclude "*dist/*"
