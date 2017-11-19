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

for i in ~/Pictures/Wallpaper/* ; do
    convert $i -resize $Yaxis ${i%%.*}_blur_resize.png
done
