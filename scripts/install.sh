#!/bin/bash

info () {
  printf "\r  [ \033[00;34m..\033[0m ] $1\n"
}

user () {
  printf "\r  [ \033[0;33m??\033[0m ] $1\n"
}

success () {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

fail () {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
  echo ''
  exit
}

ORIGINAL_DIR=$(pwd -P)

REPO_LOCATION=https://github.com/moliva/dotfiles.git
DOTFILES=$HOME/dotfiles

info "cloning dotfiles into home"
cd $HOME
git clone $REPO_LOCATION $DOTFILES
cd $DOTFILES

info "installing dotfiles"

info "initializing submodule(s)"
git submodule update --init --recursive

if [ "$(uname)" == "Darwin" ]; then
    info "running on OSX"

    # creating tmp dir for installation
    local TMP_DIR="~/.tmpdotfilesinstallation"
    mkdir -p TMP_DIR

    info "installing powerline fonts"
    git clone https://github.com/powerline/fonts.git $TMP_DIR/powerlinefonts
    sh $TMP_DIR/powerlinefonts/install.sh
    success "powerline fonts installed"

    info "installing homebrew"
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    success "homebrew installed"

    info "brewing all the things"
    source scripts/brew.sh
    success "hombrew deps installed"

    info "updating OSX settings"
    source scripts/osx.sh
    success "OSX settings set"

    info "installing node + npm (from nvm)"
    nvm install stable
    nvm alias default stable
    success "node + npm installed"

    info "installing node tools (from npm)"
    source scripts/npm.sh
    success "NPM tools installed"

    info "installing VIm plugins"
    source scripts/vim-install.sh
    success "VIm plugins installed"

    source scripts/symlink.sh

    # deleting tmp dir
    rm -fr $TMP_DIR
fi

info "configuring zsh as default shell"
chsh -s $(which zsh)

success "installed dotfiles"

cd $ORIGINAL_DIR
env zsh
