#!/bin/bash
# ===== Install moduls for i3 =====
# Install an alternative for i3status
sudo apt-get install i3blocks -y

# Graphic application finder, A Graphic replace for dmenu
sudo apt-get install xfce4-appfinder -y

# Test application finder, A test replace for dmenu
sudo apt-get install j4-dmenu-desktop -y

# Text folder size viewer
sudo apt-get install gt5 -y

# Network Manaer
sudo apt-get install network-manager -y

# Volume Controller
sudo apt-get install pnmixer -y 

rm $HOME/.config/i3/config
ln -s $(pwd)/i3/config $HOME/.config/i3/config

rm $HOME/.i3blocks.conf
ln -s $(pwd)/i3/i3blocks.conf $HOME/.i3blocks.conf
