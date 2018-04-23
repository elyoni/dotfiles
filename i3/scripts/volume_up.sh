#!/bin/bash
HOST=$(hostname -s)
#--no-startup-id pactl set-sink-mute 1 toggle 
#zenity --error --text="hello world"
case $HOST in
    "johnny-PC")
        # zenity --error --text="hello world"
        exec pactl set-sink-volume 1 +5% | exec pkill -RTMIN+10 i3blocks
        ;;
    "yehonatane-ubnt")
        #zenity --error --text="hello world"
        exec pactl set-sink-volume 0 +3% | exec pkill -RTMIN+10 i3blocks
        ;;
    "yehonatane-ltu")
        #zenity --error --text="hello world"
        exec pactl set-sink-volume 1 +3% | exec pkill -RTMIN+10 i3blocks
        ;;
    "johnny-1015PEM")
        exec pactl set-sink-volume 0 +5% | exec pkill -RTMIN+10 i3blocks
        ;;
esac

