#!/bin/bash

set -euo pipefail

echo "🚀 Setting up your Mac..."

ARCH=$(uname -m)
DOTFILES="${DOTFILES:-$HOME/.dotfiles}"

echo "🔍 Detected architecture: $ARCH"

# === 1. Install Oh My Zsh if missing ===
if ! command -v zsh >/dev/null 2>&1; then
  echo "⚙️ Installing Oh My Zsh..."
  /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
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

# === 4. Symlink Configs ===
echo "🔗 Setting up dotfiles..."

link_file() {
  local src="$1"
  local dest="$2"

  if [ -e "$dest" ] || [ -L "$dest" ]; then
    rm -rf "$dest"
  fi
  ln -s "$src" "$dest"
}

link_file "$DOTFILES/symlink/zshrc" "$HOME/.zshrc"
link_file "$DOTFILES/symlink/npmrc" "$HOME/.npmrc"
link_file "$DOTFILES/symlink/curlrc" "$HOME/.curlrc"
link_file "$DOTFILES/symlink/editorconfig" "$HOME/.editorconfig"
link_file "$DOTFILES/symlink/gitignore_global" "$HOME/.gitignore_global"
link_file "$DOTFILES/symlink/gitconfig" "$HOME/.gitconfig"
mkdir -p "$HOME/.vim" && link_file "$DOTFILES/symlink/vimrc" "$HOME/.vim/.vimrc"

# === 5. Final Touches ===
echo "⬆️ Upgrading all Brew packages..."
brew upgrade

echo "🧹 Cleaning up..."
brew cleanup

echo "✅ Finished dotstrapping!"
