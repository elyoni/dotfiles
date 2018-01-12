#!/bin/bash
#bash wallpaper_shrink.sh

array=( ~/Pictures/Wallpaper/resize/* )
number_of_picture=${#array[@]}

i=$(( RANDOM % $number_of_picture ))
while true; do
    echo "${array[$i]}"
    feh --bg-center ${array[$i]} 
    echo ${array[$i]} > ~/.background
    i=$(($i+1))
    i=$(($i%$number_of_picture))
    sleep 1h
done
