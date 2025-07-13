#!/usr/bin/env bash

if [[ -f "$(which ghostty)" ]]; then
    ghostty "$@"
elif [[ -f "$(which gnome-terminal)" ]]; then
    gnome-terminal "$@"
elif [[ -f "$(which wezterm)" ]]; then
    wezterm "$@"
elif [[ -f "$(which kitty)" ]]; then
    kitty "$@"
fi
