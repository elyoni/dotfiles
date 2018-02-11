#!/bin/bash

LAYOUT=$(setxkbmap -print | awk -F"+" '/xkb_symbols/ {print $2}')
if [ $LAYOUT = "il" ]; then
    echo "he";
else
    echo "us";
fi
