#!/bin/bash
# To use this lambda-style script from anywhere (don't put a path on the script):
# $~/src/urbaneng/tools/run-all.sh create-skymasks.sh /opt/data/clear/BigRapids/traversal-runs
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
filename="${1%.*}"
for d in $2/*/
do
    lastdir=$(basename -- $d)
    $SCRIPT_DIR/$1 $d > $lastdir.skymasks.out 2>&1
done

