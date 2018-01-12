#!/bin/bash
wallpaper=$(<~/.background)
#output=${wallpaper%/*}"/lockPic.png"
output_dir=${wallpaper%/*}"/lock"
Yaxis=4000
mkdir $output_dir 
#for i in $(xrandr --current | grep '*' | uniq | awk '{print $1}' | cut -d 'x' -f2) ;  do
for i in $(xrandr --current | grep '*' | uniq | awk '{print $1}') ;  do
    echo $i
    output=${wallpaper%/*}"/lock/"$i"lockPic.png"
    convert $wallpaper -gravity center -background "rgb(0,0,0)" -extent $i $output
done

merge_pic=( $output_dir"/*" )
convert -blur 0x8 $merge_pic +append $output_dir"/lock.png"
i3lock -i $output_dir"/lock.png" -c '#000000'
rm $output_dir/*
