#!/bin/bash
# create symbolic link for nvim to use vim profile
mkdir -p ~/.config/nvim
ln -s "$DOTFILES/vim/vimrc.symlink" "$HOME/.config/nvim/init.vim"

# install vim plugins
git clone https://github.com/VundleVim/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim
vim +PluginInstall +qall
