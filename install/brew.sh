ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew tap homebrew/versions
brew tap homebrew/dupes
brew update
brew upgrade

# Programming Languanges
brew install node nvm
brew install nvm
brew install go
brew install elixir
brew install adoptopenjdk
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