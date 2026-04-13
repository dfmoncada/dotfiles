#!/usr/bin/env bash
# Auto-sync ~/dotfiles for Claude + OpenCode config across machines.
# Modes: pull (SessionStart), push (Stop). Never fails the caller.

REPO="$HOME/dotfiles"
LOG="$HOME/.claude/sync.log"
MODE="${1:-pull}"
PATHS=(.claude .config/opencode)

[ -d "$REPO/.git" ] || exit 0

log() { echo "[$(date -Iseconds 2>/dev/null || date)] [$MODE] $*" >>"$LOG"; }

cd "$REPO" 2>/dev/null || exit 0

case "$MODE" in
  pull)
    timeout 15 git fetch --quiet origin 2>>"$LOG" || { log "fetch failed/skipped"; exit 0; }
    timeout 15 git pull --rebase --autostash --quiet 2>>"$LOG" || log "pull failed"
    ;;
  push)
    dirty=0
    for p in "${PATHS[@]}"; do
      [ -e "$p" ] || continue
      if ! git diff --quiet HEAD -- "$p" 2>/dev/null; then dirty=1; break; fi
      if [ -n "$(git ls-files --others --exclude-standard -- "$p" 2>/dev/null)" ]; then dirty=1; break; fi
    done
    [ "$dirty" -eq 0 ] && exit 0
    for p in "${PATHS[@]}"; do [ -e "$p" ] && git add -- "$p" 2>>"$LOG"; done
    host="$(hostname -s 2>/dev/null || hostname)"
    git -c user.email="dfmoncada@gmail.com" -c user.name="Diego Moncada" \
      commit -m "chore(sync): auto-sync from $host" --quiet 2>>"$LOG" || { log "nothing to commit"; exit 0; }
    timeout 15 git push --quiet origin HEAD 2>>"$LOG" || log "push failed (will retry next session)"
    ;;
esac
exit 0
