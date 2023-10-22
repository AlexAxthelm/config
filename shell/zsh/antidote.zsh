#! /bin/zsh
# https://getantidote.github.io/
# https://github.com/mattmc3/antidote
export ZSH_ANTIDOTE_DIR="$XDG_CONFIG_HOME/shell/zsh/antidote"
export ANTIDOTE_HOME="$XDG_CONFIG_HOME/shell/zsh/plugins"

zstyle ':antidote:bundle' use-friendly-names 'yes'

az_completions_dir="$XDG_CACHE_HOME/azure-cli_completions"
az_completions_path="$az_completions_dir/azure-cli_completions.plugin.zsh"
if [ ! -s "$az_completions_path" ]; then
  if [ ! -d "$az_completions_dir" ]; then
    echo "Creating directory for azure-cli completions: $az_completions_dir"
    mkdir -p "$az_completions_dir"
  fi
  echo "Downloading completions for azure-cli"
  wget "https://raw.githubusercontent.com/Azure/azure-cli/dev/az.completion" \
  -O "$az_completions_path"
fi
autoload -U +X bashcompinit && bashcompinit

if [ ! -d "$ZSH_ANTIDOTE_DIR" ]; then
  echo "$ZSH_ANTIDOTE_DIR does not exist. Cloning form GitHub."
  git clone --depth=1 https://github.com/mattmc3/antidote.git "$ZSH_ANTIDOTE_DIR"
fi

source $ZSH_ANTIDOTE_DIR/antidote.zsh
antidote load "$XDG_CONFIG_HOME/shell/zsh/zsh_plugins.txt"

# allow bash completions (useful for azure-cli)
source $az_completions_path
