#!/bin/bash
INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command')

# Block pip commands - enforce uv
if echo "$COMMAND" | grep -qE '(^|&&|\|\||;)\s*(pip|pip3)\s+(install|add|remove|uninstall)'; then
  echo "Blocked: use 'uv pip' instead of pip for package management." >&2
  exit 2
fi

# Block poetry commands - enforce uv
if echo "$COMMAND" | grep -qE '(^|&&|\|\||;)\s*poetry\s+(add|install|remove|update)'; then
  echo "Blocked: use 'uv' instead of poetry for package management." >&2
  exit 2
fi

# Block pipenv commands - enforce uv
if echo "$COMMAND" | grep -qE '(^|&&|\|\||;)\s*pipenv\s+(install|uninstall)'; then
  echo "Blocked: use 'uv' instead of pipenv for package management." >&2
  exit 2
fi

exit 0
