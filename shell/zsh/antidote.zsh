#! /bin/zsh
# https://getantidote.github.io/
# https://github.com/mattmc3/antidote
export ZSH_ANTIDOTE_DIR="$XDG_CONFIG_HOME/shell/zsh/antidote"
export ANTIDOTE_HOME="$XDG_CONFIG_HOME/shell/zsh/plugins"

if [ ! -d "$ZSH_ANTIDOTE_DIR" ]; then
  echo "$ZSH_ANTIDOTE_DIR does not exist. Cloning form GitHub."
  git clone --depth=1 https://github.com/mattmc3/antidote.git "$ZSH_ANTIDOTE_DIR"
fi

source $ZSH_ANTIDOTE_DIR/antidote.zsh
antidote load "$XDG_CONFIG_HOME/shell/zsh/zsh_plugins.txt"
