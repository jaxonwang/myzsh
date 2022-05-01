#!/usr/bin/env bash

git clone https://github.com/jaxonwang/myzsh.git $HOME/myzsh
cat << EOF >> ~/.zshrc
source $HOME/myzsh/base.zsh
EOF

