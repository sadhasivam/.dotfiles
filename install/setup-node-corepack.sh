#!/usr/bin/env bash
set -euo pipefail

# scripts/setup-node-corepack.sh
# Purpose: Ensure Node installed/active via mise, then configure corepack -> pnpm/yarn.

############################################
# Config (override via env vars if you want)
############################################
NODE_VERSION="${NODE_VERSION:-lts}"          # lts, 22, 24.13.1, etc.
PNPM_VERSION="${PNPM_VERSION:-latest}"       # or pin like 9.15.0
YARN_VERSION="${YARN_VERSION:-stable}"       # or pin like 4.6.0

# Optional: clean noisy npm settings that cause warnings (off by default)
CLEAN_NPMRC="${CLEAN_NPMRC:-0}"

############################################
# Helpers
############################################
log() { printf "\n[%s] %s\n" "$(date +'%H:%M:%S')"; printf " %s\n" "$*"; }
die() { echo "ERROR: $*" >&2; exit 1; }
require_cmd() { command -v "$1" >/dev/null 2>&1 || die "Missing command: $1"; }

ensure_mise_activated() {
  if ! mise env >/dev/null 2>&1; then
    cat <<'EOF'
mise installed but not activated in this shell.

Fix (zsh):
  echo 'eval "$(mise activate zsh)"' >> ~/.zshrc
  exec zsh -l

Then re-run: scripts/setup-node-corepack.sh
EOF
    exit 1
  fi
}

############################################
# Main
############################################
log "Checking prerequisites..."
require_cmd mise
eval "$(mise activate bash)"
hash -r

ensure_mise_activated

log "Installing + activating Node via mise: node@${NODE_VERSION}"
mise install "node@${NODE_VERSION}"
mise use -g "node@${NODE_VERSION}"
mise reshim >/dev/null 2>&1 || true

# Refresh command hash
hash -r || true

log "Verifying node/npm are available..."
require_cmd node
require_cmd npm

log "Node: $(node -v) @ $(command -v node)"
log "npm : $(npm -v)  @ $(command -v npm)"

log "Enabling Corepack..."
require_cmd corepack
corepack enable

log "Activating pnpm@${PNPM_VERSION} and yarn@${YARN_VERSION} via Corepack..."
corepack prepare "pnpm@${PNPM_VERSION}" --activate
corepack prepare "yarn@${YARN_VERSION}" --activate

log "Verifying pnpm/yarn..."
require_cmd pnpm
require_cmd yarn
log "pnpm: $(pnpm -v) @ $(command -v pnpm)"
log "yarn: $(yarn -v) @ $(command -v yarn)"

if [ "${CLEAN_NPMRC}" = "1" ]; then
  log "Cleaning deprecated/unknown npm config keys (optional)..."
  npm config delete metrics-registry >/dev/null 2>&1 || true
  npm config delete cache-max >/dev/null 2>&1 || true
fi

log "Done Node setup."
