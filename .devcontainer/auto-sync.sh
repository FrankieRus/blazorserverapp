#!/usr/bin/env bash
set -euo pipefail

SYNC_PID_FILE="/tmp/blazorserverapp-sync.pid"
SYNC_LOG_FILE="/tmp/blazorserverapp-sync.log"
INTERVAL="${AUTO_SYNC_INTERVAL:-15}"
BRANCH="${AUTO_SYNC_BRANCH:-main}"

echo "$$" > "$SYNC_PID_FILE"
echo "[$(date -u '+%Y-%m-%dT%H:%M:%SZ')] Auto-sync started (PID $$, branch=${BRANCH}, interval=${INTERVAL}s)"

while true; do
  sleep "$INTERVAL"

  CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || true)"
  if [ "$CURRENT_BRANCH" != "$BRANCH" ]; then
    continue
  fi

  if [ -n "$(git status --porcelain 2>/dev/null || true)" ]; then
    continue
  fi

  if ! git fetch origin "$BRANCH" --quiet 2>/dev/null; then
    continue
  fi

  LOCAL_SHA="$(git rev-parse HEAD 2>/dev/null || true)"
  REMOTE_SHA="$(git rev-parse "origin/${BRANCH}" 2>/dev/null || true)"

  if [ -n "$LOCAL_SHA" ] && [ -n "$REMOTE_SHA" ] && [ "$LOCAL_SHA" != "$REMOTE_SHA" ]; then
    echo "[$(date -u '+%Y-%m-%dT%H:%M:%SZ')] New commit detected (${LOCAL_SHA:0:7} -> ${REMOTE_SHA:0:7}). Pulling and restarting..."
    if git pull --ff-only origin "$BRANCH"; then
      SKIP_AUTO_SYNC=1 bash .devcontainer/start.sh || true
    else
      echo "[$(date -u '+%Y-%m-%dT%H:%M:%SZ')] Fast-forward pull skipped (local branch diverged)."
    fi
  fi
done
