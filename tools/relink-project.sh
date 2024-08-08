#!/bin/bash
# Recreates the symbolic links necessary to run opensfm selected actions after submodels are created
# These links are lost when uploaded to s3.
for d in $1/submodels/*/
do
    pushd $d
    ln -sf ../../camera_models.json
    ln -sf ../../exif
    ln -sf ../../features
    ln -sf ../../masks
    ln -sf ../../matches
    ln -sf ../../reference_lla.json
    ln -sf ../../segmentations
    mkdir -p images
    for f in $1/images/*.png
    do
        filename=$(basename -- $f)
        ln -sf ../../../images/$filename images/$filename
    done
    #$SCRIPT_DIR/$1 $d > $lastdir.skymasks.out 2>&1
    popd
done
