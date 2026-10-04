#!/usr/bin/env bash
# Extract each .tar.lrz into a directory named after the file (without .tar.lrz).
for f in "$@"; do
  f=$(realpath "$f")
  d="${f%.tar.lrz}"
  mkdir -p "$d" && (cd "$d" && lrzuntar "$f")
done
command -v notify-send >/dev/null && notify-send "lrzuntar" "Done: $*"
