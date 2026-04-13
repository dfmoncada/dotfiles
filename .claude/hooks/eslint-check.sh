#!/bin/bash
# PostToolUse hook: warn on ESLint errors after editing frontend files
INPUT=$(cat)
FILE=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.filePath // empty')

if [ -z "$FILE" ]; then
  exit 0
fi

# Only check frontend JS/JSX/TS/TSX files
case "$FILE" in
  */frontend/apj-backoffice/src/*.js|*/frontend/apj-backoffice/src/*.jsx|*/frontend/apj-backoffice/src/*.ts|*/frontend/apj-backoffice/src/*.tsx)
    ;;
  *)
    exit 0
    ;;
esac

# Find the frontend directory
FRONTEND_DIR=$(echo "$FILE" | sed 's|/src/.*|/|')

if [ ! -f "${FRONTEND_DIR}node_modules/.bin/eslint" ]; then
  exit 0
fi

# Run eslint on the changed file (timeout 10s, warn only)
RESULT=$(cd "$FRONTEND_DIR" && npx eslint "$FILE" --no-warn-ignored --format compact 2>/dev/null | head -5)

if [ -n "$RESULT" ] && echo "$RESULT" | grep -q "Error"; then
  ERROR_COUNT=$(echo "$RESULT" | grep -c "Error")
  echo "{\"systemMessage\": \"ESLint: $ERROR_COUNT error(s) in $(basename "$FILE"). Fix before committing.\"}"
fi

exit 0
