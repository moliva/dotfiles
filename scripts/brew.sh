#!/bin/sh

# cask
brew tap caskroom/cask
brew install brew-cask
brew tap caskroom/versions

# cli tools
brew install ack
brew install tree
brew install wget

# development server setup
#brew install nginx
#brew install dnsmasq

# development tools
brew install git
brew install hub
#brew install macvim --override-system-vim
brew install vim --override-system-vim
brew install reattach-to-user-namespace
brew install tmux
brew install zsh
brew install highlight
#brew install z
brew install fasd

# building tools
brew install nvm
brew install maven
brew install gradle
brew install leiningen
brew install ghc
brew install cabal-install

# gitsh
brew tap thoughtbot/formulae
brew install gitsh

# some gui apps
brew cask install alfred
brew cask install virtualbox
brew cask install sage

# file syncing
brew cask install dropbox

# browsers
brew cask install firefox
brew cask install google-chrome

# editors
brew cask install atom
brew cask install sublime-text3
brew cask install lighttable

# media players
brew cask install vlc
brew cask install spotify
