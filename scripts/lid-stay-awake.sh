#!/bin/bash
set -e
set -o pipefail

# Toggles a systemd-logind inhibitor that blocks lid-close suspend,
# so closing the lid keeps the machine running until toggled off.
PID_FILE="${HOME}/.local/state/lid-stay-awake.pid"

mkdir -p "$(dirname "$PID_FILE")"

is_active() {
    [ -f "$PID_FILE" ] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null
}

start() {
    setsid systemd-inhibit --what=handle-lid-switch --who="lid-stay-awake" \
        --why="manually requested" --mode=block sleep infinity &
    disown
    echo $! > "$PID_FILE"
    echo "Lid-close suspend disabled. Run '$(basename "$0")' again to re-enable it."
}

stop() {
    kill "$(cat "$PID_FILE")" 2>/dev/null
    rm -f "$PID_FILE"
    echo "Lid-close suspend re-enabled."
}

if is_active; then
    stop
else
    start
fi
