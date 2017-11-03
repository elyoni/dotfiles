#!/bin/bash
echo "Main PC Install"

#=== Install Arduino ===
## After extracting the zip file enter the library and run ./install.sh
# Fix port permission
## sudo usermod -a -G dialout <username>
#sudo usermod -a -G dialout johnny
# Add ESP8266 Support
## Enter the flowing link http://arduino.esp8266.com/stable/package_esp8266com_index.json


## Install Fritzing 
sudo apt-get install fritzing -y

#=== Libre Office ===
## to install libre office we need to install aptitude
sudo apt install aptitude -y
sudo aptitude install libreoffice -y

#=== Multimedia Software ===
## KDE N Live
sudo apt-get install kdenlive -y

## Mp3 player
#sudo apt-get install rhythmbox -y # I have tried and it wan't work good
sudo apt-get install clementine -y

## Gimp
sudo apt-get install gimp -y

#=== Install keepassx ===
sudo apt-get install keepassx -y

#=== Torrent ===
sudo add-apt-repository ppa:qbittorrent-team/qbittorrent-stable -y
sudo apt-get update
sudo apt-get install qbittorrent

#=== fstab ===
mkdir /media/DATA

echo "/dev/sdc6 /media/DATA ntfs defaults 0 0"
