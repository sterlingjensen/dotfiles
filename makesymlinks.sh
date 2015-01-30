#!/bin/sh

_DIR=~/.dotfiles
_OLDDIR=~/.dotfiles_old
_FILES=".i3 .vim .bash_profile .gitconfig .i3status.conf .vimrc .Xdefaults .xinitrc"

mkdir -p $_OLDDIR
cd $_DIR

for i in $_FILES; do
  mv ~/$i $_OLDDIR/
  ln -s $_DIR/$i ~/$i
done

