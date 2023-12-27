#!/bin/bash
if hostname | grep -q johnny-ubuntu; then
    echo "this is home pc"
    xrandr --output DVI-I-1 --off --output HDMI-1 --off  #Must have to fix the foucs of the screens
    #xrandr --output HDMI-1 --mode 1920x1080 --output DVI-I-1 --mode 1920x1200 --right-of HDMI-1
    xrandr --output HDMI-0 --pos 0x72 --auto --output DVI-I-1 --pos 1920x0 --auto
elif hostname | grep -q yoni-pc; then
    echo "this is work computer"
    #xrandr --output DVI-I-1 --off --output HDMI-1 --off  #Must have to fix the foucs of the screens
    xrandr --output DP-1 --auto --output HDMI-1 --auto --right-of DP-1
fi
