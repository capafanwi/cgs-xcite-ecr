#!/bin/bash
pushd .

mkdir -p $1/segmentations
mkdir -p $1/masks

cd ~/src/detectron2/
stufflist=$( seq 1 60 | grep -v 40 )

TIMEFORMAT='Process took %lR to complete.'
time {
  echo '** Making masks **'
  python makeMasks.py --batch-size 2 --invert --global-mask $1/$2 --individual-mask $1/skymask/ --mask-extension ".png.png" \
	--confidence-threshold 0.5 --config-file ./configs/Misc/panoptic_fpn_R_101_dconv_cascade_gn_3x.yaml \
	--mask-output $1/masks/ --input $1/images/*.png \
	--opts MODEL.WEIGHTS detectron2://Misc/panoptic_fpn_R_101_dconv_cascade_gn_3x/139797668/model_final_be35db.pkl \
	INPUT.MAX_SIZE_TEST 1600

  echo '** Making segmentations **'
  python makeMasks.py --batch-size 2 --stuff $stufflist --all-things --individual-mask $1/skymask/ \
	--seg-extension ".png.png" --confidence-threshold 0.5 \
	--config-file ./configs/Misc/panoptic_fpn_R_101_dconv_cascade_gn_3x.yaml --seg-output $1/segmentations/ \
	--input $1/images/*.png --opts MODEL.WEIGHTS detectron2://Misc/panoptic_fpn_R_101_dconv_cascade_gn_3x/139797668/model_final_be35db.pkl \
	INPUT.MAX_SIZE_TEST 1600
}
popd

