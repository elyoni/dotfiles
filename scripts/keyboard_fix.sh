#!/bin/bash
setxkbmap us,il

# Reset all options
setxkbmap -option

# Use Alt+Shift to change languages
setxkbmap -option 'grp:alt_shift_toggle'
