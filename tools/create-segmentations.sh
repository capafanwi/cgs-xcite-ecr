#!/bin/bash
pushd .

PROJECT_NAME=$1
CONFIG_FILE=$2

#cd /detectron2-scripts/

TIMEFORMAT='Process tool %lR to complete.'
time {
  echo '** Making masks **'
  python /detectron2-scripts/makeMasks.py --masks --config ${PROJECT_NAME}/${CONFIG_FILE} |& tee ${PROJECT_NAME}/Detectron_masks.log

  echo '** Making segmentations **'
  python /detectron2-scripts/makeMasks.py --segmentations --config ${PROJECT_NAME}/${CONFIG_FILE} |& tee ${PROJECT_NAME}/Detectron_segmentations.log
}
popd
