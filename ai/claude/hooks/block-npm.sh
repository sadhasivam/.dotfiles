#!/bin/bash
INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command')

# Check if the command starts with npm (as a command, not just mentioned in a string)
if echo "$COMMAND" | grep -qE '(^|&&|\|\||;)\s*npm\s'; then
  echo "Blocked: use pnpm, not npm." >&2
  exit 2
fi

exit 0
