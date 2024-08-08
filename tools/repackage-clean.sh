#!/bin/bash
rm tiles_clean 2> /dev/null
python ~/s3-python-utils/exif/extractExifTransform.py -i . --output transform.mat --alt-matrix transform_alt.mat
python ~/s3-python-utils/exif/applyExifTransform.py -i . --tileset tiles/tileset.json --transform transform_alt.mat --suffix _alt
python ~/s3-python-utils/exif/applyExifTransform.py -i . --tileset tiles/tileset.json --transform transform.mat
echo Repackaging
sfm-utils package-3d-tiles --in tiles/tileset_geo.json --out tiles_clean
cp tiles/tileset*.json tiles_clean
echo Done
