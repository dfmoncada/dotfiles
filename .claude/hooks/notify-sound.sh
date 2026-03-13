#!/bin/bash
# Play distinct sounds based on session outcome
INPUT=$(cat)
EXIT_CODE=$(echo "$INPUT" | jq -r '.tool_input.exit_code // .exit_code // empty')
STOP_REASON=$(echo "$INPUT" | jq -r '.stop_reason // empty')

# Error indicators: non-zero exit, or error/failure in stop reason
if [ "$EXIT_CODE" != "" ] && [ "$EXIT_CODE" != "0" ] && [ "$EXIT_CODE" != "null" ]; then
  afplay /System/Library/Sounds/Basso.aiff &
elif echo "$STOP_REASON" | grep -qiE 'error|fail|abort'; then
  afplay /System/Library/Sounds/Basso.aiff &
else
  afplay /System/Library/Sounds/Glass.aiff &
fi

exit 0
