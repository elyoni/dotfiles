#!/bin/bash
if xrandr | grep -q DVI-I-1; then
    echo "hello world"
    xrandr --output DVI-I-1 --off
    xrandr --output DVI-I-1 --auto --output HDMI-3 --auto --left-of DVI-I-1
else
    #xrandr --output HDMI-1 --auto --output DP-1 --auto --output HDMI-1 --auto --right-of DP-1
    xrandr --output HDMI-1 --auto --output DP-1 --auto --output HDMI-1 --auto --right-of DP-1
fi




