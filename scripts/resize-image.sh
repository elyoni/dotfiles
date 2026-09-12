#!/bin/bash
set -e
set -o pipefail

# Resizes one or more images to a size picked from an fzf menu, using
# ImageMagick's `convert -resize <W>x<H>\> -quality <Q>` so images already
# smaller than the target are left untouched. Output keeps the original
# name with the chosen size appended (photo.jpg -> photo-720.jpg).

if [ "$#" -eq 0 ]; then
    echo "Usage: $(basename "$0") <image> [image...]" >&2
    exit 1
fi

PRESETS="480  (thumbnail, quality 82)
720  (small, quality 85)
1080 (medium, quality 85)
1600 (large, quality 88)
2048 (max quality, quality 92)"

chosen="$(echo "$PRESETS" | fzf --prompt="Resize to> " --height=~40%)"
if [ -z "$chosen" ]; then
    echo "No size selected, aborting." >&2
    exit 1
fi

size="$(echo "$chosen" | awk '{print $1}')"
quality="$(echo "$chosen" | grep -oP 'quality \K[0-9]+')"

for input in "$@"; do
    if [ ! -f "$input" ]; then
        echo "Skipping missing file: $input" >&2
        continue
    fi

    dir="$(dirname "$input")"
    base="$(basename "$input")"
    name="${base%.*}"
    ext="${base##*.}"
    output="${dir}/${name}-${size}.${ext}"

    convert "$input" -resize "${size}x${size}>" -quality "$quality" "$output"
    echo "Wrote $output"
done
