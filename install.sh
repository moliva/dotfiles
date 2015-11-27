#!/bin/bash

source scripts/echoing-functions.sh

info "installing dotfiles"

info "initializing submodule(s)"
git submodule update --init --recursive

if [ "$(uname)" == "Darwin" ]; then
    info "running on OSX"

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
    vim +PluginInstall +qall
    success "VIm plugins installed"

    source scripts/symlink.sh
fi

info "configuring zsh as default shell"
chsh -s $(which zsh)

sucess "installed dotfiles"
