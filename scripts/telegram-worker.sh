#!/usr/bin/env bash
# Telegram → OpenCode worker
# Polls for new Telegram messages and executes them via opencode run
# Usage: ./telegram-worker.sh [poll_interval_seconds]

set -euo pipefail

POLL_INTERVAL="${1:-10}"
OFFSET_FILE="$HOME/.telegram-worker-offset"
LOG_FILE="$HOME/Documents/Obsidian Vault/Claude Code/Telegram Tasks.md"

# Load secrets (check common locations)
for envfile in "$HOME/.env" "$HOME/.zshrc.local" "$HOME/.secrets"; do
  if [ -f "$envfile" ]; then
    set +e
    set -a
    source "$envfile" 2>/dev/null
    set +a
    set -e
  fi
done

# Ensure env vars
if [ -z "${TELEGRAM_BOT_TOKEN:-}" ] || [ -z "${TELEGRAM_CHAT_ID:-}" ]; then
  echo "ERROR: TELEGRAM_BOT_TOKEN and TELEGRAM_CHAT_ID must be set"
  echo "Add them to ~/.zshrc.local"
  exit 1
fi

API="https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}"

# Initialize offset
if [ -f "$OFFSET_FILE" ]; then
  OFFSET=$(cat "$OFFSET_FILE")
else
  OFFSET=0
fi

send_reply() {
  local msg="$1"
  curl -s "$API/sendMessage" \
    -d "chat_id=${TELEGRAM_CHAT_ID}" \
    -d "text=${msg}" \
    -d "parse_mode=Markdown" >/dev/null 2>&1
}

log_task() {
  local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
  echo "- \`$timestamp\` $1" >> "$LOG_FILE"
}

echo "🤖 Telegram worker started (polling every ${POLL_INTERVAL}s)"
echo "   Bot: @Moncadasbot → opencode"
echo "   Log: $LOG_FILE"
echo ""

# Create log file if needed
mkdir -p "$(dirname "$LOG_FILE")"
touch "$LOG_FILE"

while true; do
  # Fetch updates
  UPDATES=$(curl -s "$API/getUpdates?offset=${OFFSET}&timeout=5" 2>/dev/null)

  if [ -z "$UPDATES" ] || ! echo "$UPDATES" | jq -e '.ok' >/dev/null 2>&1; then
    sleep "$POLL_INTERVAL"
    continue
  fi

  # Process each message
  echo "$UPDATES" | jq -c '.result[]' 2>/dev/null | while read -r update; do
    UPDATE_ID=$(echo "$update" | jq -r '.update_id')
    CHAT_ID=$(echo "$update" | jq -r '.message.chat.id // empty')
    TEXT=$(echo "$update" | jq -r '.message.text // empty')
    FROM=$(echo "$update" | jq -r '.message.from.first_name // "unknown"')

    # Update offset
    echo $((UPDATE_ID + 1)) > "$OFFSET_FILE"
    OFFSET=$((UPDATE_ID + 1))

    # Only process messages from Diego's chat
    if [ "$CHAT_ID" != "$TELEGRAM_CHAT_ID" ]; then
      continue
    fi

    # Skip empty or /start
    if [ -z "$TEXT" ] || [ "$TEXT" = "/start" ]; then
      continue
    fi

    # Handle special commands
    case "$TEXT" in
      /status)
        send_reply "🟢 Worker alive. Polling every ${POLL_INTERVAL}s."
        continue
        ;;
      /stop)
        send_reply "🛑 Worker stopping."
        log_task "STOP: worker stopped via Telegram"
        exit 0
        ;;
    esac

    echo "[$(date '+%H:%M:%S')] Task from $FROM: $TEXT"
    log_task "TASK: $TEXT"
    send_reply "⏳ Working on it..."

    # Run via opencode
    WORKDIR="$HOME/Projects/eztask/backend"
    OUTPUT=$(opencode run \
      --agent coordinator \
      --dir "$WORKDIR" \
      "$TEXT" 2>&1 | tail -50)

    # Send result back (truncate to 4000 chars for Telegram limit)
    RESULT=$(echo "$OUTPUT" | tail -30 | head -c 4000)
    if [ -z "$RESULT" ]; then
      RESULT="Done (no output)"
    fi

    send_reply "✅ Done:
\`\`\`
${RESULT}
\`\`\`"
    log_task "DONE: $TEXT"

  done

  sleep "$POLL_INTERVAL"
done
