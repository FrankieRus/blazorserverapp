#!/usr/bin/env bash
set -euo pipefail

PID_FILE="/tmp/blazorserverapp.pid"
LOG_FILE="/tmp/blazorserverapp.log"
PORT="${PORT:-5080}"

if [ -f "$PID_FILE" ]; then
  OLD_PID="$(cat "$PID_FILE" || true)"
  if [ -n "$OLD_PID" ] && kill -0 "$OLD_PID" 2>/dev/null; then
    kill "$OLD_PID" 2>/dev/null || true
    sleep 1
  fi
  rm -f "$PID_FILE"
fi

# Start the Blazor Server app detached so it stays running after postStartCommand finishes.
setsid dotnet run --no-launch-profile --project BlazorServerApp.csproj --urls "http://0.0.0.0:${PORT}" </dev/null >"$LOG_FILE" 2>&1 &
NEW_PID=$!
echo "$NEW_PID" > "$PID_FILE"

for _ in $(seq 1 30); do
  if curl -fsS "http://127.0.0.1:${PORT}/health" >/dev/null 2>&1; then
    echo "BlazorServerApp is running on port ${PORT} (PID ${NEW_PID}). Logs: ${LOG_FILE}"
    exit 0
  fi
  if ! kill -0 "$NEW_PID" 2>/dev/null; then
    echo "BlazorServerApp exited unexpectedly. Last log lines:" >&2
    tail -n 50 "$LOG_FILE" >&2 || true
    exit 1
  fi
  sleep 1
done

echo "BlazorServerApp started (PID ${NEW_PID}), still warming up. Check ${LOG_FILE}"
