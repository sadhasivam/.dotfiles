#!/bin/sh

echo "Setting up your Mac......"

# Check for Oh My Zsh and install if we don't have it
if test ! $(which zsh); then
  /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/HEAD/tools/install.sh)"
fi

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>$HOME/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Removes .zshrc from $HOME (if it exists) and symlinks the .zshrc file from the .dotfiles
rm -rf $HOME/.zshrc
ln -s $HOME/.dotfiles/.zshrc $HOME/.zshrc

# Update Homebrew recipes
brew update

if ( brew cask --version; ) < /dev/null > /dev/null 2>&1; then
    echo 'Caskroom tapped already'
fi

if ( brew bundle check; ) < /dev/null > /dev/null 2>&1; then
    echo 'Brewfiles enabled'
else
    brew tap Homebrew/bundle;
    brew bundle --file $DOTFILES/install/Brewfile
fi

rm -rf $HOME/.vim/ && mkdir $HOME/.vim/  && ln $DOTFILES/symlink/vimrc $HOME/.vim/.vimrc   
rm -rf $HOME/.npmrc && ln $DOTFILES/symlink/npmrc $HOME/.npmrc

rm -rf $HOME/.curlrc && ln $DOTFILES/symlink/curlrc $HOME/.curlrc    
rm -rf $HOME/.gitignore_global && ln $DOTFILES/git/.gitignore_global $HOME/.gitignore_global
rm -rf $HOME/.gitconfig && ln $DOTFILES/git/.gitconfig $HOME/.gitconfig

# Upgrade all to latest 
brew upgrade

# Remove outdated versions from the cellar.
brew cleanup
echo "Finished dotstrapping...."
