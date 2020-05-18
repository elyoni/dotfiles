#!/bin/bash

# base dir for backlight class
basedir="/sys/class/backlight/"

# get the backlight handler
handler=$basedir$(ls $basedir)"/"
echo $handler

# get current brightness
old_brightness=$(cat $handler"brightness")

# get max brightness
max_brightness=$(cat $handler"max_brightness")
echo max_brightness $max_brightness

# get current brightness %
old_brightness_p=$(( 100 * $old_brightness / $max_brightness ))
echo old_brightness_p $old_brightness_p

# calculate new brightness % 
new_brightness_p=$(($old_brightness_p $1))

# calculate new brightness value
new_brightness=$(( $max_brightness * $new_brightness_p / 100 ))
echo $new_brightness

if [ $new_brightness -gt $max_brightness ]; then
    new_brightness=${max_brightness}
elif [ $new_brightness -lt 10 ]; then
    new_brightness=10
fi

# set the new brightness value
sudo chmod 666 $handler"brightness"

echo $new_brightness > $handler"brightness"
