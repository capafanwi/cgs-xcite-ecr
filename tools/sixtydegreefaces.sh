#!/bin/bash
for i in {0,30,60}
do
	nohup ffmpeg -i images/0-%d.png -vf "v360=e:c6x1:out_forder=rludfb:yaw=$i" cubemaps/images$i/cube%d.png &
	nohup ffmpeg -i masks/0-%d.png.png -vf "v360=e:c6x1:out_forder=rludfb:yaw=$i" cubemaps/masks$i/cube%d.png &
done
echo Waiting for cubemaps...
wait
for i in {0,60}
do 
	nohup ffmpeg -i cubemaps/images$i/cube%d.png -vf "crop=ih:ih:ih*4:0" faces/F"$i"_%d.png -vf "crop=ih:ih:ih*5:0" faces/B"$i"_%d.png &
	nohup ffmpeg -i cubemaps/masks$i/cube%d.png -vf "crop=ih:ih:ih*4:0" faces/F"$i"_%d_mask.tif -vf "crop=ih:ih:ih*5:0" faces/B"$i"_%d_mask.tif &
	echo $i
done
nohup ffmpeg -i cubemaps/images30/cube%d.png -vf "crop=ih:ih:0:0" faces/R30_%d.png -vf "crop=ih:ih:ih:0" faces/L30_%d.png &
nohup ffmpeg -i cubemaps/masks30/cube%d.png -vf "crop=ih:ih:0:0" faces/R30_%d_mask.tif -vf "crop=ih:ih:ih:0" faces/L30_%d_mask.tif &
echo Waiting for faces...
wait
echo Translating faces...
if [0]
then
for i in {0,60}
do 
	echo $i
	for j in {1..5210}
	do
		mv faces/F"$i"_$j.png faces/Ang"$i"/F/F"$i"_0-$((j-1)).png
		mv faces/B"$i"_$j.png faces/Ang"$i"/B/B"$i"_0-$((j-1)).png
		mv faces/F"$i"_"$j"_mask.tif faces/Ang"$i"/F/F"$i"_0-$((j-1))_mask.tif
		mv faces/B"$i"_"$j"_mask.tif faces/Ang"$i"/B/B"$i"_0-$((j-1))_mask.tif
	done
done
fi
for j in {1..5210}
do
	mv faces/L30_$j.png faces/Ang30/L/L30_0-$((j-1)).png
	mv faces/R30_$j.png faces/Ang30/R/R30_0-$((j-1)).png
	mv faces/L30_"$j"_mask.tif faces/Ang30/L/L30_0-$((j-1))_mask.tif
	mv faces/R30_"$j"_mask.tif faces/Ang30/R/R30_0-$((j-1))_mask.tif
done
echo Done
