#!/bin/bash

HOST=$(hostname -s)
#--no-startup-id pactl set-sink-mute 1 toggle 
#zenity --error --text="hello world"
case $HOST in
    "johnny-PC")
        # zenity --error --text="hello world"
        exec pactl set-sink-mute 1 toggle | exec pkill -RTMIN+10 i3blocks
        ;;
    "johnny-1015PEM")
        exec pactl set-sink-mute 0 toggle | exec pkill -RTMIN+10 i3blocks
        ;;
esac
