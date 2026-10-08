#!/usr/bin/env sh
set -eu

if [ ! -d $HOME/.fzf ]; then
  git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
  $HOME/.fzf/install
fi

if [ ! -f $HOME/.vim/autoload/plug.vim ]; then
  curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

for f in "$PWD"/.*; do
  [ -f "$f" ] || continue
  ln -vsf "$f" "$HOME/${f##*/}"
done
