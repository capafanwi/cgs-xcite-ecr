#!/bin/bash
for d in $1/*/
do
    lastdir=$(basename -- $d)
    bash -c "time ~/src/urbaneng/tools/create-segmentations.sh $d" > $lastdir.segmentations.out 2>&1
done

