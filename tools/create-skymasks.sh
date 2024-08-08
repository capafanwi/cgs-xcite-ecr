#!/bin/bash
pushd .

PROJECT_NAME=$1
CONFIG_FILE=$2

TIMEFORMAT='Process tool %lR to complete.'
time {
SkyMask --config-file ${PROJECT_NAME}/${CONFIG_FILE} |& tee ${PROJECT_NAME}/SkyMask.log
}
popd
