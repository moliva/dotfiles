#!/bin/bash
git clone https://github.com/VundleVim/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim
vim +PluginInstall +qall

mkdir -p ~/.config/nvim
ln -s "$DOTFILES/vim/vimrc.symlink" "$HOME/.config/nvim/init.vim"
