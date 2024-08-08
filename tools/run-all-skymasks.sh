#!/bin/bash
for d in $1/*/
do
    lastdir=$(basename -- $d)
    ~/src/urbaneng/tools/create-skymasks.sh $d > $lastdir.skymasks.out 2>&1
done

