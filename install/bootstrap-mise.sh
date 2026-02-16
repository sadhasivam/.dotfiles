#!/usr/bin/env bash
set -euo pipefail

# scripts/bootstrap-mise.sh
# Purpose: Install/activate runtimes via mise (java/python/etc) then delegate Node setup.
# Assumes: Homebrew + mise already installed. Shell must be configured with: eval "$(mise activate zsh)"

############################################
# Config (edit these)
############################################
# Global defaults you want active everywhere:
DEFAULT_NODE="${DEFAULT_NODE:-24.13.1}"
DEFAULT_PYTHON="${DEFAULT_PYTHON:-3.14.3}"
DEFAULT_JAVA="${DEFAULT_JAVA:-25}"
DEFAULT_MAVEN="${DEFAULT_MAVEN:-3.9.9}"
DEFAULT_GRADLE="${DEFAULT_GRADLE:-8.7}"

# Versions you want installed (kept available) in addition to defaults:
PYTHON_VERSIONS=("${DEFAULT_PYTHON}" )
JAVA_VERSIONS=("${DEFAULT_JAVA}" )
MAVEN_VERSIONS=("${DEFAULT_MAVEN}")
GRADLE_VERSIONS=("${DEFAULT_GRADLE}")

# If you want Go/Ruby/etc later, add arrays similarly.

# Where the node setup script lives
NODE_SETUP_SCRIPT="${NODE_SETUP_SCRIPT:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/setup-node-corepack.sh}"

############################################
# Helpers
############################################
log() { printf "\n[%s] %s\n" "$(date +'%H:%M:%S')" "$*"; }
die() { echo "ERROR: $*" >&2; exit 1; }

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || die "Missing command: $1"
}

ensure_mise_activated() {
  # Node not showing up "by default" is almost always because mise shims aren't on PATH.
  # This checks for that condition and tells you exactly what to do.
  if ! mise env >/dev/null 2>&1; then
    cat <<'EOF'
mise appears installed but not activated in this shell.

Fix (zsh):
  echo 'eval "$(mise activate zsh)"' >> ~/.zshrc
  exec zsh -l

Then re-run: scripts/bootstrap-mise.sh
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

log "Installing runtimes (python/java) via mise..."
for v in "${PYTHON_VERSIONS[@]}"; do
  log "Installing python@${v}"
  mise install "python@${v}" || true
done

for v in "${JAVA_VERSIONS[@]}"; do
  log "Installing java@${v}"
  mise install "java@${v}" || true
done

log "Installing build tools (maven/gradle) via mise..."

for v in "${MAVEN_VERSIONS[@]}"; do
  log "Installing maven@${v}"
  mise install "maven@${v}" || true
done

for v in "${GRADLE_VERSIONS[@]}"; do
  log "Installing gradle@${v}"
  mise install "gradle@${v}" || true
done

log "Reshim + show current..."
mise reshim >/dev/null 2>&1 || true
mise current || true

log "Delegating Node setup to: ${NODE_SETUP_SCRIPT}"
[ -x "${NODE_SETUP_SCRIPT}" ] || die "Node setup script is not executable: ${NODE_SETUP_SCRIPT}. Run: chmod +x ${NODE_SETUP_SCRIPT}"
"${NODE_SETUP_SCRIPT}"

log "Setting global defaults (active everywhere)..."
mise use -g "python@${DEFAULT_PYTHON}"
mise use -g "java@${DEFAULT_JAVA}"
mise use -g "maven@${DEFAULT_MAVEN}"
mise use -g "gradle@${DEFAULT_GRADLE}"
mise use -g "node@${DEFAULT_NODE}" >/dev/null 2>&1 || true  # node might be handled by node script too
mise exec -- corepack enable
mise exec -- corepack prepare pnpm@latest --activate
mise exec -- corepack prepare yarn@stable --activate

log "Done."
