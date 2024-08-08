#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
numprocs=$(grep -c ^processor /proc/cpuinfo)
shopt -s nullglob
numfiles=($1/images/*.png)
numfiles=${#numfiles[@]}
echo $numfiles
((j=numfiles/numprocs+1))
start=0
stop=1
for ((i=1; i<=$numprocs; i++))
do
    ((start=(i-1)*j))
    ((stop=i*j-1))
    echo $i, $j, $start, $stop
    $SCRIPT_DIR/create-faces.sh $1 $start $stop &
done
wait
rm -r $1/cubes
echo Done
