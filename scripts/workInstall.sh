#!/bin/bash

echo "workInstall"
# === For synergy ===
sudo apt-get install libavahi-compat-libdnssd1 -y
sudo apt-get install synergy -y


# === SVN side by side compair ===
sudo pip install --upgrade cdiff

