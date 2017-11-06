#!/bin/bash

LAYOUT=$(setxkbmap -print | awk -F"+" '/xkb_symbols/ {print $2}')
if [ $LAYOUT = "il" ]; then
    setxkbmap -layout us
    echo "israel";
else
    setxkbmap -layout il
    echo "us";
fi
