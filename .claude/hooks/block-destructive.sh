#!/bin/bash
# Block destructive commands in Bash tool calls
INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

if [ -z "$COMMAND" ]; then
  exit 0
fi

# BLOCK: catastrophic operations (exit 2 = deny)
if echo "$COMMAND" | grep -iE '\b(rm\s+-rf\s+/|DROP\s+(DATABASE|TABLE|SCHEMA)|TRUNCATE\s+TABLE|mkfs\.|dd\s+if=|>\s*/dev/sd|format\s+[a-z]:)\b' > /dev/null; then
  echo "Blocked: Potentially destructive command detected. Review manually." >&2
  exit 2
fi

# BLOCK: dangerous git operations
if echo "$COMMAND" | grep -iE '(push\s+.*--force|push\s+-f\b|reset\s+--hard|clean\s+-f|checkout\s+\.\s*$|branch\s+-D)' > /dev/null; then
  echo "Blocked: Destructive git operation. Review manually." >&2
  exit 2
fi

# WARN: risky but allowed (systemMessage = yellow warning)
if echo "$COMMAND" | grep -iE '\b(rm\s+-rf|DROP|TRUNCATE|DELETE\s+FROM|ALTER\s+TABLE.*DROP)\b' > /dev/null; then
  echo '{"systemMessage": "Warning: this command modifies or deletes data. Proceeding with caution."}'
  exit 0
fi

exit 0
