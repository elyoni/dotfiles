#!/bin/bash

echo "General Install"

#=== Pyton ===
sudo apt-get install python -y
sudo apt-get install python3 -y
sudo apt-get install python-pip -y
sudo apt-get install python3-pip -y
pip install --upgrade pip
pip3 install --upgrade pip

#=== PDF Reader ===
sudo apt-get install okular

#=== Browser ===
sudo apt-get install chromium-broser
sudo apt-get intall firefox

echo "Install i3"
bash i3/install.sh

echo "Install VIM & VIMRC"
bash vim/install.sh

echo "Install Double Commander"
bash DoubleCommander/install.sh

echo "Install tmux"
bash tmux/install.sh
