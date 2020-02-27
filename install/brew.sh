if ( brew --version ) < /dev/null > /dev/null 2>&1; then
    echo 'Homebrew is already installed!'
else
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)";
fi

if ( brew cask --version; ) < /dev/null > /dev/null 2>&1; then
    echo 'Caskroom tapped already'
else
    brew tap homebrew/cask-cask;
fi

if ( brew bundle check; ) < /dev/null > /dev/null 2>&1; then
    echo 'Brewfiles enabled'
else
    brew tap Homebrew/bundle;
    brew bundle;
fi

brew cleanup;
brew prune;
brew doctor;


# Programming Languanges
brew install node
brew install nvm
brew install go
brew install elixir
brew cask install adoptopenjdk
brew install gradle

# Utilities 
brew install zsh
brew install jq
brew install tree
brew install tmux
brew install wifi-password

## cloud ops
brew install kubernetes-cli
brew install kubectl
brew install awscli
brew install aws-okta
brew install terraform

# development
brew install git
brew install htop
brew install nmap
brew install wget
brew install caddy
# self certificate experiment
brew install step 

# Cask
brew tap caskroom/cask
brew install brew-cask
brew tap caskroom/versions

brew cask install --appdir="/Applications" 
