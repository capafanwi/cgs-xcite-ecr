#!/bin/bash
PROJECT_NAME=$1
CONFIG_FILE=$2
TILES=$3
sfm-utils build-tiles --load ${PROJECT_NAME}/${CONFIG_FILE} |& tee ${PROJECT_NAME}/build_${TILES}.log
python /s3-python-utils/exif/solveExifTransform.py -i ${PROJECT_NAME} --no-trust-gps --tileset ${PROJECT_NAME}/${TILES}/tileset.json
mv ${PROJECT_NAME}/${TILES}/tileset_geo.json ${PROJECT_NAME}/${TILES}/tileset_alt.json
python /s3-python-utils/exif/solveExifTransform.py -i ${PROJECT_NAME} --tileset ${PROJECT_NAME}/${TILES}/tileset.json
sfm-utils package-3d-tiles --in ${PROJECT_NAME}/${TILES}/tileset_geo.json --out ${PROJECT_NAME}/${TILES}_clean
cp ${PROJECT_NAME}/${TILES}/tileset*.json ${PROJECT_NAME}/${TILES}_clean
