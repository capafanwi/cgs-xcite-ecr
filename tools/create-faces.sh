#!/bin/bash
part1=$1
mkdir -p $part1/faces/B
mkdir -p $part1/faces/F
mkdir -p $part1/faces/R
mkdir -p $part1/faces/L
mkdir -p $part1/faces/U
mkdir -p $part1/faces/D
mkdir -p $part1/cubes

images=($part1/images/*.png)
for ((i=$2; i<=$3; i++))
do
    f="${images[$i]}"
    if [[ -f $f ]] ; then 
        fn=$(basename "$f")
        echo $fn
        ffmpeg -i $f -vf "v360=e:c6x1:out_forder=rludfb" $part1/cubes/"$fn"cube%d.png -v 0
        ffmpeg -i $part1/cubes/"$fn"cube1.png -vf untile=6x1 $part1/faces/F%d_$fn -v 0
        mv $part1/faces/F1_$fn $part1/faces/R/R_$fn
        mv $part1/faces/F2_$fn $part1/faces/L/L_$fn
        mv $part1/faces/F3_$fn $part1/faces/U/U_$fn
        mv $part1/faces/F4_$fn $part1/faces/D/D_$fn
        mv $part1/faces/F5_$fn $part1/faces/F/F_$fn
        mv $part1/faces/F6_$fn $part1/faces/B/B_$fn
    fi
done

masks=($part1/masks/*.png)
for ((i=$2; i<=$3; i++))
do
    f="${masks[$i]}"
    if [[ -f $f ]] ; then 
        fn=$(basename "$f")
        fn0="${fn%.*}"
        fn1="${fn0%.*}"
        echo $fn1
        ffmpeg -i $f -vf "v360=e:c6x1:out_forder=rludfb" $part1/cubes/"$fn1"cube%d_mask.tif -v 0
        ffmpeg -i $part1/cubes/"$fn1"cube1_mask.tif -vf untile=6x1 $part1/faces/F%d_"$fn1"_mask.tif -v 0
        mv $part1/faces/F1_"$fn1"_mask.tif $part1/faces/R/R_"$fn1"_mask.tif
        mv $part1/faces/F2_"$fn1"_mask.tif $part1/faces/L/L_"$fn1"_mask.tif
        mv $part1/faces/F3_"$fn1"_mask.tif $part1/faces/U/U_"$fn1"_mask.tif
        mv $part1/faces/F4_"$fn1"_mask.tif $part1/faces/D/D_"$fn1"_mask.tif
        mv $part1/faces/F5_"$fn1"_mask.tif $part1/faces/F/F_"$fn1"_mask.tif
        mv $part1/faces/F6_"$fn1"_mask.tif $part1/faces/B/B_"$fn1"_mask.tif
    fi
done