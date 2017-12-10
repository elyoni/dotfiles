#!/bin/bash
file_path="$HOME/.time_idle"
counter=$(<$file_path)
seconds=$((counter%60))
minutes=$((counter/60%60))
hours=$((counter/60/60%24))
if [[ $hours -gt 0 ]]; then 
    printf '%02d:' $hours && printf '%02d:' $minutes && printf '%02d\n' $seconds
elif [[ $minutes -gt 0 ]]; then 
    printf '%02d:' $minutes && printf '%02d\n' $seconds
elif [[ $seconds -gt 0 ]]; then 
    printf '%02d\n' $seconds
fi
