#!/bin/bash

convert $HOME/Pictures/wallpaper.JPG -blur 0x20 -resize 1920x1080 wallpaper_blur1080.png
convert $HOME/Pictures/wallpaper.JPG -blur 0x20 -resize 1920x1200 wallpaper_blur1200.png
convert $HOME/Pictures/wallpaper_blur1080.png wallpaper_blur1200.png +append wallpaper.png
i3lock -i wallpaper.png
