#!/usr/bin/env bash

if [[ -f "$(which wezterm)" ]]; then
    wezterm "$@"
elif [[ -f "$(which kitty)" ]]; then
    kitty "$@"
elif [[ -f "$(which gnome-terminal)" ]]; then
    gnome-terminal "$@"
fi
