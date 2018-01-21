#!/bin/bash
if hostname | grep -q johnny-ubuntu; then
    echo "this is home pc"
    xrandr --output DVI-I-1 --off --output HDMI-1 --off  #Must have to fix the foucs of the screens
    xrandr --output HDMI-1 --mode 1920x1080 --output DVI-I-1 --mode 1920x1200 --right-of HDMI-1
elif hostname | grep -q yehonatane-ubnt; then
    echo "this is work computer"
    #xrandr --output DVI-I-1 --off --output HDMI-1 --off  #Must have to fix the foucs of the screens
    xrandr --output HDMI-1 --auto --output DP-1 --auto --output HDMI-1 --auto --right-of DP-1
fi
