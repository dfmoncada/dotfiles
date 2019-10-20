#!/bin/sh

base="${0%/*}"

function rm_or_backup() {
  file_name=$1
  if find $HOME -maxdepth 1 -type l -ls | grep "\\${file_name}$"; then
    rm -r $HOME/$file_name
  elif find $HOME -maxdepth 1 -ls | grep "\\${file_name}$"; then
    echo "backed up ~/$file_name to ~/$file_name.backup"
    mv $HOME/$file_name $HOME/$file_name.backup
  fi
}

rm_or_backup .zs
rm_or_backup .zshrc
rm_or_backup .vim
rm_or_backup .tmux.conf

ln -s $base/.zsh $HOME/.zsh
ln -s $base/.zshrc $HOME/.zshrc
ln -s $base/.vim $HOME/.vim
ln -s $base/.tmux.conf $HOME/.tmux.conf
