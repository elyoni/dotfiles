#!/bin/bash
DIR=$(dirname "${BASH_SOURCE[0]}")
DIR=$(cd -P $DIR && pwd)


mkdir $HOME/.config/i3/scripts

sudo apt-get install i3 -y

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

sudo apt-get install feh -y

# Screen manager
sudo apt-get install arandr -y 

# Volume Controller
sudo apt-get install pnmixer -y 
ln -sf $DIR/scripts/volume.sh   $HOME/.config/i3/scripts/volume.sh

ln -sf $DIR/scripts/xrander_script.sh $HOME/.config/i3/scripts/xrander_script.sh
ln -sf $DIR/scripts/lang.sh $HOME/.config/i3/scripts/lang.sh

rm $HOME/.config/i3/config
ln -sf $DIR/config $HOME/.config/i3/config

rm $HOME/.i3blocks.conf
ln -sf $DIR/i3blocks.conf $HOME/.i3blocks.conf

bash $DIR/i3blocks/scripts/idle_time/install.sh

gsettings set org.gnome.desktop.background show-desktop-icons false
