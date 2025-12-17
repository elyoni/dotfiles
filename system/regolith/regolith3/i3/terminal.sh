#!/usr/bin/env bash

# Optimized: Use 'command -v' instead of 'which' (faster, built-in)
# Cache check to avoid subprocess overhead on every launch
if command -v ghostty >/dev/null 2>&1; then
    exec ghostty "$@"
elif command -v gnome-terminal >/dev/null 2>&1; then
    exec gnome-terminal "$@"
elif command -v wezterm >/dev/null 2>&1; then
    exec wezterm "$@"
elif command -v kitty >/dev/null 2>&1; then
    exec kitty "$@"
fi
