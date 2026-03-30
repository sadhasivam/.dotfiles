#!/bin/bash

set -euo pipefail

echo "🚀 Setting up your Mac..."

ARCH=$(uname -m)
DOTFILES="${DOTFILES:-$HOME/.dotfiles}"

echo "🔍 Detected architecture: $ARCH"

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
echo "🔄 Updating Homebrew..."
brew update

if ! brew bundle check --file="$DOTFILES/install/Brewfile"; then
  echo "📦 Installing Brew bundle..."
  brew bundle --file="$DOTFILES/install/Brewfile"
else
  echo "✅ Brew bundle already satisfied."
fi

echo "🧰 Bootstrapping runtimes via mise..."
# === 4. Setup Node ===
bash "$DOTFILES/install/bootstrap-mise.sh"

echo "✅ mise bootstrap complete"

# === 5. Symlink Configs ===
echo "🔗 Setting up dotfiles..."

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

link_file "$DOTFILES/symlink/zshrc" "$HOME/.zshrc"
link_file "$DOTFILES/symlink/npmrc" "$HOME/.npmrc"
link_file "$DOTFILES/symlink/pnpmrc" "$HOME/.pnpmrc"
link_file "$DOTFILES/symlink/curlrc" "$HOME/.curlrc"
link_file "$DOTFILES/symlink/editorconfig" "$HOME/.editorconfig"
mkdir -p "$HOME/.vim" && link_file "$DOTFILES/symlink/vimrc" "$HOME/.vim/.vimrc"
mkdir -p "$HOME/.config/mise" && link_file "$DOTFILES/symlink/mise.toml" "$HOME/.config/mise/config.toml"

# Claude Code configuration
mkdir -p "$HOME/.claude"
link_file "$DOTFILES/ai/claude/settings.json" "$HOME/.claude/settings.json"
link_file "$DOTFILES/ai/claude/hooks" "$HOME/.claude/hooks"

# Git configuration
link_file "$DOTFILES/git/gitconfig" "$HOME/.gitconfig"
link_file "$DOTFILES/git/gitignore_global" "$HOME/.gitignore_global"
git config --global core.hooksPath "$DOTFILES/git/hooks"

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

# === 5. Final Touches ===
echo "⬆️ Upgrading all Brew packages..."
brew upgrade

echo "🧹 Cleaning up..."
brew cleanup

echo "✅ Finished dotstrapping!"
