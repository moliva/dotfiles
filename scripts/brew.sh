#!/usr/bin/env sh

# sql formatter
brew install pgformatter

# rust
# linker
brew install michaeleisel/zld/zld

# starship cli
brew install starship

# cli tools
brew install ack
brew install gawk # for better tmux copycat support
brew install tree
brew install wget
brew install pstree

brew install 1password-cli

brew install --cask ngrok
brew install --cask wezterm

# development server setup
brew install docker
# brew install dnsmasq

# development tools + utils
brew install git
brew install vim --override-system-vim
brew install reattach-to-user-namespace
brew install tmux
brew install zsh
brew install highlight
# brew install z
# brew install fasd
brew install zoxide
brew install watch
brew install coreutils # installs gsort (for git tag semantic ordering)
brew install jq        # filter/accessor for command line for json and other formats
brew install entr

# filters for enhancd
brew tap jhawthorn/fzy
brew install fzy ccat

# building tools
brew install fnm
# brew install npm # use nvm to install node to avoid errors
# brew install ant
# brew install maven
# brew install gradle
# brew install leiningen
# brew install ghc
# brew install cabal-install
# brew install heroku-toolbelt

# installing joe for gitignores
# brew tap karan/karan
# brew install gitignore

# other dev tools
# brew install mongodb
# brew install redis

# production gui apps
brew install --cask alfred
brew install --cask sizeup
brew install --cask caffeine
brew install --cask clipy

# quick looks
brew install --cask qlstephen
brew install --cask qlcolocode
brew install --cask qlmarkdown
brew install --cask quicklook-json

# some gui apps + utils
brew install --cask keycastr
brew install --cask licecap
brew install --cask utorrent
brew install --cask calibre
brew install --cask adobe-reader
brew install --cask unrarx
brew install --cask gimp

# file syncing
brew install --cask dropbox
brew install --cask evernote
brew install --cask tuxera-ntfs

# browsers
brew install --cask google-chrome

# media players
brew install --cask vlc
brew install --cask spotify
