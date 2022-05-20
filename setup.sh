#!/usr/bin/env bash

set -e
set -x

(cd tmux-widget && cargo build --release)

if ! grep myzsh/base.zsh ~/.zshrc; then

cat << EOF >> ~/.zshrc
source $HOME/myzsh/base.zsh
EOF

fi

if [[ ! -e ~/.tmux.conf ]]; then
    ln -s $HOME/myzsh/tmux.conf ~/.tmux.conf
fi
