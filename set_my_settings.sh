#!/bin/bash

echo "# ================================"
echo "# Installing the KDE settings"
echo "# ================================"

echo "Copy my kde keyboard settings"
cp KDESettings/kglobalshortcutsrc $HOME/.config/
cp KDESettings/khotkeysrc $HOME/.config/
echo "Copy input settings"
cp KDESettings/kcminputrc $HOME/.kde/share/config/
echo "Copy KDE UI color"
cp KDESettings/kdeglobals $HOME/.kde/share/config/
cp KDESettings/plasma-org.kde.plasma.desktop-appletsrc $HOME/.config/
cp KDESettings/plasmashellrc $HOME/.config/
echo "Copy Dolphon settings"
cp KDESettings/.directory $HOME/
echo "Copy widgets settings"
cp KDESettings/.gtkrc-2.0 $HOME/
cp KDESettings/gtkrc $HOME/.config/
echo "Copy kate settings"
cp KDESettings/katepartrc $HOME/.config
echo "Copy kwin settings"
cp KDESettings/kwinrc $HOME/.config
echo "Double Commander Settings"
cp DoubleCommander/doublecmd.xml $HOME/.config/doublecmd
cp DoubleCommander/shortcuts.scf $HOME/.config/doublecmd
echo "TMUX Configurion"
cp tmux/.tmux.conf $HOME/
