#!/bin/bash


DEVICE_KEYBOARD_ID=$(xinput list | grep -E "AT Translated Set 2 keyboard|Another Device|Some Other Device" | awk -F'id=' '{print $2}' | awk '{print $1}')

DEVICE_TRACKPAD_ID=$(xinput list | grep -E "TrackPoint" | awk -F'id=' '{print $2}' | awk '{print $1}')
if xinput list-props $DEVICE_KEYBOARD_ID | grep "Device Enabled (.*):.*1" > /dev/null
then
    xinput disable $DEVICE_KEYBOARD_ID
    xinput disable $DEVICE_TRACKPAD_ID
    echo "Keyboard disabled"
else
    xinput enable $DEVICE_KEYBOARD_ID
    xinput enable $DEVICE_TRACKPAD_ID
    echo "Keyboard enabled"
fi
