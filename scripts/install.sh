#!/bin/bash

info() {
  printf "\r  [ \033[00;34m..\033[0m ] $1\n"
}

user() {
  printf "\r  [ \033[0;33m??\033[0m ] $1\n"
}

success() {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

fail() {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
  echo ''
  exit
}

ORIGINAL_DIR=$(pwd -P)

REPO_LOCATION=https://github.com/moliva/dotfiles.git
DOTFILES=$HOME/dotfiles

info "cloning dotfiles into home"
cd "$HOME" || return
git clone "$REPO_LOCATION" "$DOTFILES"
cd "$DOTFILES" || return

info "installing dotfiles"

info "initializing submodule(s)"
git submodule update --init --recursive

if [ "$(uname)" == "Darwin" ]; then
  info "running on macOS"

  info "creating tmp dir for installation"
  TMP_DIR=$(mktemp -d)
  cd "$TMP_DIR" || return
  success tmp dir created at "$TMP_DIR"

  info "installing font"
  curl -o font.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/JetBrainsMono.zip
  unzip font.zip -d ./font
  cp ./font/* "$HOME/Library/Fonts"
  success "font installed"

  # TODO - check if homebrew not installed first - moliva - 2024/12/16
  info "checking homebrew"
  if ! which brew >/dev/null; then
    info "homebrew not found, installing"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    success "homebrew installed"
  else
    success "homebrew already installed, skipping step"
  fi

  info "brewing all the things"
  source ./scripts/brew.sh
  success "hombrew deps installed"

  info "updating macOS settings"
  source scripts/osx.sh
  success "macOS settings set"

  # TODO - use fnm - moliva - 2024/12/16
  NODE_VERSION=22
  info "installing node v$NODE_VERSION through fnm"
  fnm install "$NODE_VERSION"
  fnm default "$NODE_VERSION"
  success "node v$NODE_VERSION installed"

  info "installing node tools (from npm)"
  source scripts/npm.sh
  success "node tools installed"

  source scripts/symlink.sh

  # deleting tmp dir
  rm -fr "$TMP_DIR"
fi

info "configuring zsh as default shell"
chsh -s "$(which zsh)"

success "installed dotfiles"

cd "$ORIGINAL_DIR" || return
env zsh
