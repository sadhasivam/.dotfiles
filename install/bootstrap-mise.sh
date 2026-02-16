#!/usr/bin/env bash
set -euo pipefail

# bootstrap-mise.sh
# Purpose: Bootstrap mise-managed runtimes from declarative config (symlink/mise.toml)
# Assumes: Homebrew + mise already installed, mise.toml symlinked to ~/.config/mise/config.toml

############################################
# Helpers
############################################
log() { printf "\n[%s] %s\n" "$(date +'%H:%M:%S')" "$*"; }
die() { echo "ERROR: $*" >&2; exit 1; }

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || die "Missing command: $1"
}

ensure_mise_activated() {
  if ! mise env >/dev/null 2>&1; then
    cat <<'EOF'
⚠️  mise appears installed but not activated in this shell.

Fix (zsh):
  echo 'eval "$(mise activate zsh)"' >> ~/.zshrc
  exec zsh -l

Then re-run: install/bootstrap-mise.sh
EOF
    exit 1
  fi
}

############################################
# Main
############################################
log "Checking prerequisites..."
require_cmd mise

# Activate mise in this script session
eval "$(mise activate bash)"
hash -r

ensure_mise_activated

log "Installing all tools from ~/.config/mise/config.toml..."
log "Versions are defined in: symlink/mise.toml"
mise install

log "Verifying installed tools..."
mise current || true

log "Enabling corepack for package.json 'packageManager' field support..."
mise exec -- corepack enable

log "✅ mise bootstrap complete!"
log "   All runtime versions are managed in: symlink/mise.toml"
log "   To change versions, edit that file and re-run this script."
