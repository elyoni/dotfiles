#!/bin/bash

LAYOUT=$(setxkbmap -print | awk -F"+" '/xkb_symbols/ {print $2}')
if [ $LAYOUT = "il" ]; then
    setxkbmap -layout us | exec pkill -SIGRTMIN+11 i3blocks#-RTMIN+3 i3blocks
    echo "us";
else
    setxkbmap -layout il | exec pkill -SIGRTMIN+11 i3blocks#-RTMIN+3 i3blocks
    echo "he";
fi
