#!/usr/bin/env bash
exec 2>>/tmp/herdr-move-pane.log
set -x
trap 'echo "--- FAILED at line $LINENO ---" >> /tmp/herdr-move-pane.log; sleep 5' ERR
set -euo pipefail

echo "PATH=$PATH" >> /tmp/herdr-move-pane.log
command -v fzf jq herdr >> /tmp/herdr-move-pane.log 2>&1

PANE_ID="$HERDR_ACTIVE_PANE_ID"
WORKSPACE_ID="${PANE_ID%%:*}"

CHOICE=$(herdr tab list --workspace "$WORKSPACE_ID" \
  | jq -r '.result.tabs[] | "\(.tab_id)\t\(.label // .tab_id)"' \
  | fzf --delimiter='\t' --with-nth=2 --prompt="Move pane → tab: ")

[ -z "$CHOICE" ] && exit 0
TAB_ID=$(printf '%s' "$CHOICE" | cut -f1)

DIRECTION=$(printf 'right\ndown' | fzf --prompt="Split direction: ")
[ -z "$DIRECTION" ] && exit 0

herdr pane move "$PANE_ID" --tab "$TAB_ID" --split "$DIRECTION" --focus
