# Node.js and package manager configuration

# Ensure mise uses standalone pnpm instead of Node's bundled corepack version
if command -v mise >/dev/null 2>&1; then
  # Get the expected standalone pnpm path
  local expected_pnpm="$HOME/.local/share/mise/installs/pnpm/latest/pnpm"

  # Get what mise is currently using
  local current_pnpm=$(mise which pnpm 2>/dev/null)

  # If they don't match and standalone exists, remove Node's pnpm and reshim
  if [ -n "$current_pnpm" ] && [ -x "$expected_pnpm" ] && [ "$current_pnpm" != "$expected_pnpm" ]; then
    # Find and remove pnpm from Node's bin directory
    local node_pnpm_path=$(echo "$current_pnpm" | grep -E "node/[^/]+/bin/pnpm$")
    if [ -n "$node_pnpm_path" ]; then
      rm -f "$node_pnpm_path" "$node_pnpm_path"x 2>/dev/null
      mise reshim pnpm 2>/dev/null
    fi
  fi
fi
