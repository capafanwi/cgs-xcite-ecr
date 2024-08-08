#!/bin/bash

PROJECT_NAME=$1
CONFIG_FILE=$2

TIMEFORMAT='Process took %lR to complete.'
time {
 opensfm extract_metadata ${PROJECT_NAME} |& tee ${PROJECT_NAME}/extract_metadata.log
 opensfm detect_features  ${PROJECT_NAME} |& tee ${PROJECT_NAME}/detect_features.log
 opensfm match_features   ${PROJECT_NAME} |& tee ${PROJECT_NAME}/match_features.log

# Now split into subprojects!!!
 #opensfm create_submodels ${PROJECT_NAME} |& tee ${PROJECT_NAME}/create_submodels.log
 sfm-utils run-submodels --load ${PROJECT_NAME}/${CONFIG_FILE} --create-submodels |& tee ${PROJECT_NAME}/create-submodels.log

# Parallel
#Below is commented alternative command to run that will still work.
 #sfm-utils run-submodels --subprojectsFolder ${PROJECT_NAME}/submodels --create-tracks |& tee ${PROJECT_NAME}/create-tracks.log
 sfm-utils run-submodels --load ${PROJECT_NAME}/${CONFIG_FILE} --create-tracks |& tee ${PROJECT_NAME}/create-tracks.log
 sfm-utils run-submodels --load ${PROJECT_NAME}/${CONFIG_FILE} --reconstruct |& tee ${PROJECT_NAME}/reconstruct.log

 #opensfm align_submodels ${PROJECT_NAME} |& tee ${PROJECT_NAME}/align_submodels.log
 sfm-utils run-submodels --load ${PROJECT_NAME}/${CONFIG_FILE} --align-submodels |& tee ${PROJECT_NAME}/align-submodels.log

# Parallel
 sfm-utils run-submodels --load ${PROJECT_NAME}/${CONFIG_FILE} --undistort |& tee ${PROJECT_NAME}/undistort.log
 sfm-utils run-submodels --load ${PROJECT_NAME}/${CONFIG_FILE} --depthmaps |& tee ${PROJECT_NAME}/depthmaps.log
 sfm-utils run-submodels --load ${PROJECT_NAME}/${CONFIG_FILE} --export-visualsfm |& tee ${PROJECT_NAME}/export-visualsfm.log
 sfm-utils nvm-to-json --load ${PROJECT_NAME}/${CONFIG_FILE} > ${PROJECT_NAME}/nvm.json
 sfm-utils run-submodels --load ${PROJECT_NAME}/${CONFIG_FILE} --export-openmvs |& tee ${PROJECT_NAME}/export-openmvs.log
}
