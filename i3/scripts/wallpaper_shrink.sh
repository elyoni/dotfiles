#!/bin/bash
#Get Minimal Xaxis
Xaxis=4000
for i in $(xrandr --current | grep '*' | uniq | awk '{print $1}' | cut -d 'x' -f1) ;  do
    if [ "$i" -lt "$Xaxis" ] ; then
        Xaxis=$i
    fi
done
#Get Minimal Xaxis
Yaxis=4000
for i in $(xrandr --current | grep '*' | uniq | awk '{print $1}' | cut -d 'x' -f2) ;  do
    if [ "$i" -lt "$Yaxis" ] ; then
        Yaxis=$i
    fi
done
echo "Xaxis: $Xaxis"
echo "Yaxis: $Yaxis"


mkdir ~/Pictures/Wallpaper/resize/
for i in ~/Pictures/Wallpaper/* ; do
    if [ -f $i ] ; then
        newFile=${i%/*}"/resize/"$(basename ${i%.*})"_blur_resize.png"
        echo $newFile
        convert $i -resize x$Yaxis $newFile
    fi
done
