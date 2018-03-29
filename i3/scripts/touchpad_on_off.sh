#!/bin/bash
state=$(synclient | grep TouchpadOff | sed 's/[^0-1]*//g')
if [ "$state" == "1" ]; then
    state="0"
    synclient TouchpadOff=0
    echo "Trun ON The Touchpad"
else
    state="1";
    synclient TouchpadOff=1
    echo "Trun OFF The Touchpad"
fi
