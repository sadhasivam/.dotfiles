#!/bin/bash

set -euo pipefail

echo "🚀 Setting up your Mac..."

ARCH=$(uname -m)
DOTFILES="${DOTFILES:-$HOME/.dotfiles}"

echo "🔍 Detected architecture: $ARCH"

# === Helper: symlink with backup ===
# Defined up front: the Homebrew trust store must be linked before `brew bundle`
# runs, which happens well before the main config-linking section below.
link_file() {
  local src="$1"
  local dest="$2"

  # If destination exists
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    # Check if it's a symlink - just remove it
    if [ -L "$dest" ]; then
      rm -rf "$dest"
    # Check if it's a real file or directory (not a symlink)
    elif [ -f "$dest" ] || [ -d "$dest" ]; then
      # Create _backup directory if it doesn't exist
      local backup_dir="$DOTFILES/_backup"
      mkdir -p "$backup_dir"

      # Create backup with timestamp
      local timestamp=$(date +"%Y%m%d_%H%M%S")
      local dest_basename=$(basename "$dest")

      # Handle extensions properly (including dotfiles)
      if [[ "$dest_basename" == .* ]]; then
        # It's a dotfile (starts with .)
        local dest_name="${dest_basename}"
        local backup_name="${dest_name}_${timestamp}"
      elif [[ "$dest_basename" == *.* ]]; then
        # Has an extension
        local dest_name="${dest_basename%.*}"
        local dest_ext="${dest_basename##*.}"
        local backup_name="${dest_name}_${timestamp}.${dest_ext}"
      else
        # No extension
        local backup_name="${dest_basename}_${timestamp}"
      fi

      local backup_path="$backup_dir/${backup_name}"

      if [ -f "$dest" ]; then
        echo "  📦 Backing up existing file: $dest -> $backup_path"
      else
        echo "  📦 Backing up existing directory: $dest -> $backup_path"
      fi
      mv "$dest" "$backup_path"
    else
      # Unknown type, remove it
      rm -rf "$dest"
    fi
  fi

  ln -s "$src" "$dest"
}

# === 1. Install Oh My Zsh if missing ===
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "⚙️ Installing Oh My Zsh..."
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi


# === 2. Install Homebrew ===
if ! command -v brew >/dev/null 2>&1; then
  echo "🍺 Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  if [[ "$ARCH" == "arm64" ]]; then
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
    eval "$(/opt/homebrew/bin/brew shellenv)"
  else
    echo 'eval "$(/usr/local/bin/brew shellenv)"' >> "$HOME/.zprofile"
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi

# === 3. Brew Update & Tap Bundle ===
#
# Homebrew 7+ refuses to load formulae from non-official taps until they are
# trusted. Trust is declared in the Brewfile via `trusted: true`, which
# `brew bundle` applies BEFORE it loads any entry -- so no trust store needs to
# be seeded here first. We used to symlink a tracked homebrew-trust.json into
# $HOME for that; it was redundant, and because `bundle cleanup --force`
# rewrites the trust store, writing through that symlink clobbered the tracked
# file. The Brewfile is now the single source of truth.
#
# `bundle check` does NOT apply trust, so on a fresh machine it reports the
# third-party entries as unmet. That is harmless: it just routes into
# `brew bundle` below, which trusts and installs them.
echo "🔄 Updating Homebrew..."
brew update

if ! brew bundle check --file="$DOTFILES/install/Brewfile"; then
  echo "📦 Installing Brew bundle..."
  brew bundle --file="$DOTFILES/install/Brewfile"
else
  echo "✅ Brew bundle already satisfied."
fi

# Remove anything installed but no longer declared in the Brewfile.
#
# `cleanup --force` also resets the trust store to whatever the Brewfile
# declares via `trusted:` options. Every third-party entry carries
# `trusted: true`, so this is a no-op reset that writes back the same values,
# and running it by hand is safe too.
#
# Do NOT reintroduce a snapshot-and-restore around this: it would put back trust
# entries that cleanup correctly pruned for packages no longer in the Brewfile.
echo "🧹 Pruning packages not declared in the Brewfile..."
brew bundle cleanup --force --file="$DOTFILES/install/Brewfile"

echo "🧰 Bootstrapping runtimes via mise..."
# === 4. Link mise config before installing runtimes ===
mkdir -p "$HOME/.config/mise"
link_file "$DOTFILES/symlink/mise.toml" "$HOME/.config/mise/config.toml"
bash "$DOTFILES/install/bootstrap-mise.sh"

echo "✅ mise bootstrap complete"

# === 5. Symlink Configs ===
echo "🔗 Setting up dotfiles..."

link_file "$DOTFILES/symlink/zshrc" "$HOME/.zshrc"
link_file "$DOTFILES/symlink/bashrc" "$HOME/.bashrc"
# ~/.npmrc is SEEDED, not symlinked: `npm config set` / `pnpm config set`
# write to it, so a symlink would push machine-local values -- including auth
# tokens -- into the tracked repo. Seed once, then leave it alone.
if [ ! -e "$HOME/.npmrc" ]; then
  cp "$DOTFILES/symlink/npmrc" "$HOME/.npmrc"
  echo "✅ Seeded ~/.npmrc from template (machine-local, not tracked)"
else
  echo "✅ ~/.npmrc already exists (left as-is)"
fi

link_file "$DOTFILES/symlink/pnpmrc" "$HOME/.pnpmrc"
link_file "$DOTFILES/symlink/curlrc" "$HOME/.curlrc"
link_file "$DOTFILES/symlink/editorconfig" "$HOME/.editorconfig"
mkdir -p "$HOME/.vim" && link_file "$DOTFILES/symlink/vimrc" "$HOME/.vim/.vimrc"

# Claude Code configuration
mkdir -p "$HOME/.claude"
link_file "$DOTFILES/ai/claude/settings.json" "$HOME/.claude/settings.json"
link_file "$DOTFILES/ai/claude/hooks" "$HOME/.claude/hooks"

# Git configuration
link_file "$DOTFILES/git/gitconfig" "$HOME/.gitconfig"
link_file "$DOTFILES/git/gitignore_global" "$HOME/.gitignore_global"
# Create .gitconfig.local if it doesn't exist (for user-specific settings).
# Must run BEFORE the hooksPath write below, which appends to this same file.
if [ ! -f "$HOME/.gitconfig.local" ]; then
  echo "⚙️  Creating ~/.gitconfig.local for user-specific git config..."
  echo "Please enter your git user details:"
  read -p "  Name: " git_name
  read -p "  Email: " git_email

  cat > "$HOME/.gitconfig.local" <<EOF
[user]
	name = $git_name
	email = $git_email
EOF
  echo "✅ Created ~/.gitconfig.local (gitignored, won't be tracked)"
else
  echo "✅ ~/.gitconfig.local already exists"
fi

# hooksPath is an absolute, machine-specific path, so it goes in the local
# file. NOT `git config --global`: ~/.gitconfig is a symlink to the tracked
# git/gitconfig, so a --global write would commit this machine's $HOME into
# the dotfiles repo.
git config --file "$HOME/.gitconfig.local" core.hooksPath "$DOTFILES/git/hooks"

VSCODE_PATH="$HOME/Library/Application Support/Code/User"

# Check if VS Code is installed
if [ -d "$VSCODE_PATH" ]; then
  echo "VS Code detected ✅"
  echo "Linking settings.json from dotfiles..."

  # Use link_file to enable backup policy
  link_file "$DOTFILES/ide/vscode/settings.json" "$VSCODE_PATH/settings.json"
else
  echo "VS Code not installed ❌ - skipping symlink"
fi

# === 6. Final Touches ===
echo "⬆️ Upgrading all Brew packages..."
brew upgrade

echo "🧹 Cleaning up..."
brew cleanup

echo "⬆️ Upgrading all  Mise packages "
mise upgrade

echo "✅ Finished dotstrapping!"
