#!/usr/bin/env bash


if [[ -f "$(which wezterm)" ]]; then
    which wezterm
elif [[ -f "$(which gnome-terminal)" ]]; then
    which gnome-terminal
fi
