#!/usr/bin/env bash

cat << EOF >> ~/.zshrc
source $HOME/myzsh/base.zsh
EOF
ln -s $HOME/myzsh/tmux.conf ~/.tmux.conf
