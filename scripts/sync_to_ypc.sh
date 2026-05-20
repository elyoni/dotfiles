#!/usr/bin/env bash
# Sync Cursor and Claude configs from local to ypc (push only).

set -euo pipefail

REMOTE="ypc"
DRY_RUN=false

if [[ "${1:-}" == "--dry-run" ]]; then
    DRY_RUN=true
    echo "[DRY RUN] No changes will be made."
fi

RSYNC_OPTS=(-avz --progress --delete)
if $DRY_RUN; then
    RSYNC_OPTS+=(--dry-run)
fi

run_rsync() {
    local src="$1"
    local dst="$2"
    shift 2
    echo ">>> $src -> $REMOTE:$dst"
    rsync "${RSYNC_OPTS[@]}" "$@" "$src" "$REMOTE:$dst"
    echo
}

echo "=== Syncing dotfiles (Cursor + Claude rules/commands) ==="
run_rsync "$HOME/.dotfiles/" "~/.dotfiles/" \
    --exclude='.git/'

echo "=== Syncing Claude settings ==="
# Sync only the non-sensitive, non-local Claude files
rsync "${RSYNC_OPTS[@]}" \
    --include='settings.json' \
    --include='keybindings.json' \
    --exclude='*' \
    "$HOME/.claude/" "$REMOTE:~/.claude/"
echo

echo "=== Done ==="
echo "On ypc, run the following to activate Cursor symlinks (first time only):"
echo "  ~/.dotfiles/applications/cursor/install install"
