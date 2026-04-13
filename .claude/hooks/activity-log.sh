#!/bin/bash
# Log Claude Code activity to Obsidian vault
INPUT=$(cat)
EVENT=$(echo "$INPUT" | jq -r '.hook_event_name // "unknown"')
TOOL=$(echo "$INPUT" | jq -r '.tool_name // empty')
CWD=$(echo "$INPUT" | jq -r '.cwd // empty')
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
PROJECT=$(basename "$CWD" 2>/dev/null)

LOG="$HOME/Documents/Obsidian Vault/Claude Code/Activity Log.md"
ARCHIVE_DIR="$HOME/Documents/Obsidian Vault/Claude Code/archive"
MAX_LINES=500

# Rotate log if over MAX_LINES
if [ -f "$LOG" ]; then
  LINE_COUNT=$(wc -l < "$LOG" | tr -d ' ')
  if [ "$LINE_COUNT" -gt "$MAX_LINES" ]; then
    mkdir -p "$ARCHIVE_DIR"
    MONTH=$(date '+%Y-%m')
    mv "$LOG" "$ARCHIVE_DIR/activity-$MONTH-$(date '+%s').md"
    echo "# Activity Log" > "$LOG"
    echo "" >> "$LOG"
    echo "_Rotated $(date '+%Y-%m-%d'). Archives in \`archive/\`._" >> "$LOG"
    echo "" >> "$LOG"
  fi
fi

case "$EVENT" in
  PreToolUse)
    case "$TOOL" in
      Bash)
        CMD=$(echo "$INPUT" | jq -r '.tool_input.command // empty' | head -c 200)
        echo "- \`$TIMESTAMP\` **[$PROJECT]** BASH: \`$CMD\`" >> "$LOG"
        ;;
      Edit|MultiEdit)
        FILE=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.filePath // empty' | sed "s|$HOME|~|")
        echo "- \`$TIMESTAMP\` **[$PROJECT]** EDIT: \`$FILE\`" >> "$LOG"
        ;;
      Write)
        FILE=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.filePath // empty' | sed "s|$HOME|~|")
        echo "- \`$TIMESTAMP\` **[$PROJECT]** WRITE: \`$FILE\`" >> "$LOG"
        ;;
      Agent)
        AGENT=$(echo "$INPUT" | jq -r '.tool_input.agent_type // .tool_input.subagent_type // empty')
        AGENT_NAME=$(echo "$INPUT" | jq -r '.tool_input.name // empty')
        echo "- \`$TIMESTAMP\` **[$PROJECT]** AGENT: \`$AGENT\`" >> "$LOG"
        # Per-agent log for tmux panes
        TEAM="${CLAUDE_TEAM_NAME:-default}"
        ALOG_DIR="$HOME/.claude/agent-logs/${TEAM}"
        if [ -n "$AGENT_NAME" ] && [ -d "$ALOG_DIR" ]; then
          echo "$(date '+%H:%M:%S') [spawn] ${AGENT_NAME} (${AGENT})" >> "${ALOG_DIR}/_team.log"
        fi
        ;;
      *)
        echo "- \`$TIMESTAMP\` **[$PROJECT]** TOOL: \`$TOOL\`" >> "$LOG"
        ;;
    esac
    ;;
  Stop)
    echo "- \`$TIMESTAMP\` **[$PROJECT]** --- session turn ended ---" >> "$LOG"
    ;;
esac

exit 0
