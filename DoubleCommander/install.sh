#!/bin/bash

#=== Install double commander ===
sudo apt-get install doublecmd-qt -y

echo "Double Commander Settings"
ln -s $(pwd)/DoubleCommander/doublecmd.xml $HOME/.config/doublecmd/doublecmd.xml
ln -s $(pwd)/DoubleCommander/shortcuts.scf $HOME/.config/doublecmd/shortcuts.scf
