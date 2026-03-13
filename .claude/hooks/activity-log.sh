#!/bin/bash
# Log Claude Code activity to Obsidian vault
INPUT=$(cat)
EVENT=$(echo "$INPUT" | jq -r '.hook_event_name // "unknown"')
TOOL=$(echo "$INPUT" | jq -r '.tool_name // empty')
CWD=$(echo "$INPUT" | jq -r '.cwd // empty')
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
PROJECT=$(basename "$CWD" 2>/dev/null)

LOG="$HOME/Documents/Obsidian Vault/Claude Code/Activity Log.md"

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
        echo "- \`$TIMESTAMP\` **[$PROJECT]** AGENT: \`$AGENT\`" >> "$LOG"
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
