#!/bin/bash

#=== Install double commander ===
sudo apt-get install doublecmd-qt -y

echo "Double Commander Settings"
ln -sf $(pwd)/DoubleCommander/doublecmd.xml $HOME/.config/doublecmd/doublecmd.xml
ln -sf $(pwd)/DoubleCommander/shortcuts.scf $HOME/.config/doublecmd/shortcuts.scf
