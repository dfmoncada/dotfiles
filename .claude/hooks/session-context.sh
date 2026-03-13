#!/bin/bash
# SessionStart hook: gather project context + Obsidian continuity
# Provides Claude with recent git activity, branch info, and prior session context

CWD=$(jq -r '.cwd // empty' < /dev/stdin)

if [ -z "$CWD" ]; then
  exit 0
fi

cd "$CWD" 2>/dev/null || exit 0

CONTEXT=""

# --- Git context ---
if command git rev-parse --is-inside-work-tree &>/dev/null; then
  BRANCH=$(command git branch --show-current 2>/dev/null)
  if [ -n "$BRANCH" ]; then
    CONTEXT+="Current branch: $BRANCH\n"
  fi

  RECENT=$(command git log --oneline -5 2>/dev/null)
  if [ -n "$RECENT" ]; then
    CONTEXT+="Recent commits:\n$RECENT\n"
  fi

  STATUS=$(command git status --short 2>/dev/null)
  if [ -n "$STATUS" ]; then
    CHANGED=$(echo "$STATUS" | wc -l | tr -d ' ')
    CONTEXT+="Uncommitted changes: $CHANGED files\n"
  fi

  if [ -f ".claude/CLAUDE.md" ]; then
    CONTEXT+="Project has .claude/CLAUDE.md\n"
  fi
fi

# --- Obsidian context for session continuity ---
OBSIDIAN="$HOME/Documents/Obsidian Vault/Claude Code"

# Last activity (tail 15 lines)
if [ -f "$OBSIDIAN/Activity Log.md" ]; then
  ACTIVITY=$(tail -15 "$OBSIDIAN/Activity Log.md" 2>/dev/null)
  if [ -n "$ACTIVITY" ]; then
    CONTEXT+="\n--- Recent activity ---\n$ACTIVITY\n"
  fi
fi

# Pending plan items
if [ -f "$OBSIDIAN/Plan.md" ]; then
  PLAN=$(grep -E '^\s*- \[ \]' "$OBSIDIAN/Plan.md" 2>/dev/null | head -10)
  if [ -n "$PLAN" ]; then
    CONTEXT+="\n--- Pending plan items ---\n$PLAN\n"
  fi
fi

# Latest decisions (last 10 lines)
if [ -f "$OBSIDIAN/Decisions.md" ]; then
  DECISIONS=$(tail -10 "$OBSIDIAN/Decisions.md" 2>/dev/null)
  if [ -n "$DECISIONS" ]; then
    CONTEXT+="\n--- Recent decisions ---\n$DECISIONS\n"
  fi
fi

if [ -n "$CONTEXT" ]; then
  echo -e "$CONTEXT"
fi

exit 0
