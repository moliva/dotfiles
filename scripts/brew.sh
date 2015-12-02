#!/bin/sh

# cask
brew tap caskroom/cask
brew install brew-cask
brew tap caskroom/versions

# gem
brew install brew-gem

# cli tools
brew install ack
brew install tree
brew install wget
brew install pstree

# development server setup
brew install docker
brew install boot2docker
#brew install nginx
#brew install dnsmasq

# development tools + utils
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
# brew install npm # use nvm to install node
brew install maven
brew install gradle
brew install leiningen
brew install ghc
brew install cabal-install
brew install heroku-toolbelt

# other dev tools
brew cask install mongodb
brew cask install vagrant

# gitsh
# brew tap thoughtbot/formulae
# brew install gitsh

# gems
brew gem install tmuxinator

# production gui apps
brew cask install alfred
brew cask install sizeup
brew cask install caffeine

# some gui apps + utils
brew cask install virtualbox
#brew cask install sage
brew cask install utorrent
brew cask install skype
brew cask install calibre
brew cask install xee
brew cask install keycastr
brew cask install adobe-reader
brew cask install unrarx

# file syncing
brew cask install dropbox
brew cask install evernote
brew cask install tuxera-ntfs
brew cask install android-file-transfer
brew cask install filezilla

# browsers
brew cask install firefox
brew cask install google-chrome

# editors
brew cask install atom
brew cask install sublime-text3
#brew cask install lighttable

# media players
brew cask install vlc
brew cask install spotify
