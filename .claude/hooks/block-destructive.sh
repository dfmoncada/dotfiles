#!/bin/bash
# Block destructive commands in Bash tool calls
INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

if [ -z "$COMMAND" ]; then
  exit 0
fi

# Block destructive operations (case-insensitive)
if echo "$COMMAND" | grep -iE '\b(rm\s+-rf\s+/|DROP\s+(DATABASE|TABLE|SCHEMA)|TRUNCATE\s+TABLE|DELETE\s+FROM\s+\S+\s*;?\s*$|mkfs\.|dd\s+if=|>\s*/dev/sd|format\s+[a-z]:)\b' > /dev/null; then
  echo "Blocked: Potentially destructive command detected. Review manually." >&2
  exit 2
fi

# Warn on risky but not blocked commands
if echo "$COMMAND" | grep -iE '\b(rm\s+-rf|DROP|TRUNCATE|DELETE\s+FROM)\b' > /dev/null; then
  echo '{"systemMessage": "Warning: this command modifies or deletes data. Proceeding with caution."}' 
  exit 0
fi

exit 0
