#!/bin/sh
# Test stand-in for "systemctl --user restart expathio": stops the old process
# (pid file in $BASE_DIR/shared) and starts server.js from the live release.
set -eu
PID_FILE="$BASE_DIR/shared/app.pid"
if [ -f "$PID_FILE" ]; then
    kill "$(cat "$PID_FILE")" 2>/dev/null || true
    sleep 1
fi
nohup node "$BASE_DIR/current/server.js" > "$BASE_DIR/shared/app.log" 2>&1 < /dev/null &
echo $! > "$PID_FILE"
