#!/bin/bash
part1=$1
mkdir -p $part1/faces/F
mkdir -p $part1/faces/B
mkdir -p $part1/faces/L
mkdir -p $part1/faces/R
mkdir -p $part1/faces/U
mkdir -p $part1/faces/D
for f in $part1/images/*.png
do
    fn=$(basename "$f")
    ffmpeg -i $f -vf "v360=e:c6x1:out_forder=rludfb" -f image2pipe pipe: | ffmpeg -i pipe: -f image2pipe -vf "crop=ih:ih:0:0" $part1/faces/R/R_$fn -vf "crop=ih:ih:ih:0" $part1/faces/L/L_$fn -vf "crop=ih:ih:ih*2:0" $part1/faces/U/U_$fn -vf "crop=ih:ih:ih*3:0" $part1/faces/D/D_$fn -vf "crop=ih:ih:ih*4:0" $part1/faces/F/F_$fn -vf "crop=ih:ih:ih*5:0" $part1/faces/B/B_$fn
done