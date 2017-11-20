#!/bin/bash
number_of_picture="$(ls ~/Pictures/Wallpaper/resize/ -afq | wc -l)"
#number_of_picture=$((number_of_picture-2))
array=( ~/Pictures/Wallpaper/resize/* )
echo ${#array[@]}
for i in "${!foo[@]}"; do 
  printf "%s\t%s\n" "$i" "${foo[$i]}"
done

for i in "${!array[@]}" ; do
    echo "${array[$i]}"
    #if [ -f $i ] ; then
    #    echo $i
    #fi
done
