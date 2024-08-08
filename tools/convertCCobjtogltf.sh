#!/bin/bash
shopt -s nullglob
mkdir -p $1/tiles
if [ -d $1/Data/000/ ]
then
    a=$1/Data
    terminateLoop=0
    count=0
    rm $1/tiles/*
    while [ $terminateLoop -eq 0 ]
    do
        for d1 in $a/*.obj
        do
            if [ ! -f $d1 ] 
            then
                terminateLoop=1
                break
            fi
            base=$(basename -- $d1)
            basename="${base%.*}"
            echo $basename
            sfm-utils obj-to-gltf -i $d1 -o $1/tiles/"$basename".gltf
            #touch $1/tiles/"$basename".gltf
            ((count++))
        done
        for i in $a/*.jpg
        do
            if [ ! -f $i ] 
            then
                break
            fi
            echo cp $i $1/tiles/
        done
        a=$a/000
    done
    ((scount=50*count))
    for f1 in $1/tiles/*.gltf
    do
        base=$(basename -- $f1)
        mv $f1 $1/tiles/"$scount"m_$base
        ((scount=scount-50))
    done
else
    for d in $1/Data/Tile*/
    do
        if [ ! -d $d ] 
        then
            break
        fi
        count=0
        base=$(basename -- $d)
        mkdir -p $1/tiles/$base
        rm -f $1/tiles/$base/*
        numfiles=("$d"*.obj)
        numfiles=${#numfiles[@]}
        index=$(((numfiles-1)%3))
        echo $base $index
        for f in "$d"*.obj
        do
            base1="$(basename -- $f)"
            basename="${base1%.*}"
            echo $basename
            if [ $index -eq 0 ]
            then
                sfm-utils obj-to-gltf -i $f -o $1/tiles/$base/"$basename".gltf
                ((count++))
                index=2
            else
                ((index--))
            fi
        done 
        for i in "$d"*.jpg
        do
            cp $i $1/tiles/$base/
        done
        ((scount=50*count))
        for f1 in $1/tiles/$base/*.gltf
        do
            tbase=$(basename -- $f1)
            mv $f1 $1/tiles/$base/"$scount"m_$tbase
            ((scount=scount-50))
        done
    done
fi