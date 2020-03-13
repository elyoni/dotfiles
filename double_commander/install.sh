#!/bin/bash
DIR=$(dirname "${BASH_SOURCE[0]}")
DIR=$(cd -P $DIR && pwd)

#=== Install double commander ===
sudo apt-get install doublecmd-qt -y

echo "Double Commander Settings"
ln -sf $DIR/doublecmd.xml $HOME/.config/doublecmd/doublecmd.xml
ln -sf $DIR/shortcuts.scf $HOME/.config/doublecmd/shortcuts.scf
ln -sf $DIR/highlighters.xml $HOME/.config/doublecmd/highlighters.xml
