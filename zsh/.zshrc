# Dotfiles
export DOTFILES=$HOME/dotfiles

# zsh related env
ZSH=$DOTFILES/zsh

# load zgen
source $DOTFILES/zgen/zgen.zsh

# adding path directory for custom scripts
export PATH=$DOTFILES/bin:$PATH

# load all sh system config files
for config ($DOTFILES/system/*.sh) source $config

# check if there's no init script
if ! zgen saved; then
    echo "Creating a zgen save"

    zgen oh-my-zsh

    # autouptdate for zgen
    zgen load unixorn/autoupdate-zgen

    # plugins from oh-my-zsh
    zgen oh-my-zsh plugins/git
    zgen oh-my-zsh plugins/sudo
    zgen oh-my-zsh plugins/command-not-found
    zgen oh-my-zsh plugins/brew
    zgen oh-my-zsh plugins/brew-cask
    zgen oh-my-zsh plugins/bower
    zgen oh-my-zsh plugins/heroku
    zgen oh-my-zsh plugins/npm
    zgen oh-my-zsh plugins/grunt
    zgen oh-my-zsh plugins/gem
    zgen oh-my-zsh plugins/sbt
    zgen oh-my-zsh plugins/docker
    zgen oh-my-zsh plugins/cabal
    zgen oh-my-zsh plugins/lein

    # other plugins
    zgen load zsh-users/zsh-syntax-highlighting
    zgen load tmuxinator/tmuxinator completion
    zgen load jimeh/tmuxifier completion
    zgen load github/hub etc

    # local plugins
    zgen load $DOTFILES zsh/plugins

    # completions
    zgen load zsh-users/zsh-completions src

    # theme
    zgen oh-my-zsh themes/robbyrussell

    # save all to init script
    zgen save
fi

# Base16 Shell
# if [ -z "$THEME" ]; then
    export THEME="base16-harmonic16"
# fi
if [ -z "$BACKGROUND" ]; then
    export BACKGROUND="dark"
fi

export BASE16_SHELL="$DOTFILES/.config/base16-shell/$THEME.$BACKGROUND.sh"
# [[ -s $BASE16_SHELL ]] && source $BASE16_SHELL
source $BASE16_SHELL

# source localrc
[ -f $HOME/.localrc ] && source $HOME/.localrc

