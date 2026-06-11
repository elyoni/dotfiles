#!/bin/bash
# Send copied text via OSC 52 for clipboard passthrough over SSH
# Usage: command | osc52-copy.sh

# Read from stdin
text=$(cat)

# Calculate base64 of the text
b64=$(printf '%s' "$text" | base64 -w0)

# Send OSC 52 escape sequence
printf '\033]52;c;%s\007' "$b64"

# Also output the text to maintain tmux buffer
printf '%s' "$text"
