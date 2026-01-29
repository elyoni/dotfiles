#!/usr/bin/env bash
function stopper()
{
    start=$(date +%s)
    while true; do
      now=$(date +%s)
      elapsed=$((now - start))
      printf "\rElapsed: %02d:%02d:%02d" \
        $((elapsed/3600)) $((elapsed%3600/60)) $((elapsed%60))
      sleep 1
    done
}
