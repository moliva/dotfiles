#!/usr/bin/env sh

# cask
brew tap caskroom/cask
brew install brew-cask
brew tap caskroom/versions

# gem
brew install brew-gem

# cli tools
brew install ack
brew install gawk # for better tmux copycat support
brew install tree
brew install wget
brew install pstree
brew install ctags

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
brew gem install tmuxinator
brew install zsh
brew install highlight
# brew install z
brew install fasd
brew install shellcheck # linter for sh scripts

# building tools
brew install nvm
# brew install npm # use nvm to install node
# brew install flow # javascript static analyzer
brew install maven
brew install gradle
brew install leiningen
brew install ghc
brew install cabal-install
brew install heroku-toolbelt

# installing joe for gitignores
brew tap karan/karan
brew install gitignore

# other dev tools
brew install mongodb

# gitsh
# brew tap thoughtbot/formulae
# brew install gitsh

# fonts
brew tap caskroom/fonts 
brew cask install font-meslo-lg-for-powerline # TODO - change for the same meslo with all font awesome icons for vim devicons support

# production gui apps
brew cask install alfred
brew cask install sizeup
brew cask install caffeine

# other dev gui tools
brew cask install vagrant
#brew cask install sage
brew cask install virtualbox

# some gui apps + utils
brew cask install keycastr
brew cask install utorrent
brew cask install skype
brew cask install calibre
brew cask install xee
brew cask install adobe-reader
brew cask install unrarx
brew cask install mucommander

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
