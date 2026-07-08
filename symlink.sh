#! /bin/sh
# create symlinks for applications that don't support XDG_CONFIG_HOME.
#
# This script is meant to be run from the root of the dotfiles repository.

ln -s $PWD/cspell/cSpell.json $HOME/.cspell.json
ln -s $PWD/finicky/finicky.js $HOME/.finicky.js
ln -s $PWD/shell/zsh/zshrc $HOME/.zshrc
# zshenv is the bootstrap (sets XDG_CONFIG_HOME); -f so a manual copy is replaced.
ln -sf $PWD/shell/zsh/zshenv $HOME/.zshenv
