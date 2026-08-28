#! /bin/sh
# Description: Export environment variables

# Don't use images for M1 Mac, since I'm mosly targeting Linux servers
export DOCKER_DEFAULT_PLATFORM="linux/amd64"
export BUILDKIT_PROGRESS="plain"

# Powerline Settings
export POWERLINE_REPOSITORY_ROOT="/opt/homebrew/lib/python3.11/site-packages"

# Homebrew
# https://github.com/Homebrew/discussions/discussions/446#discussioncomment-263078
brew_cmd="/opt/homebrew/bin/brew"
if [ -x "$brew_cmd" ]; then
  # echo "INFO: brew found ($brew_cmd)"
  eval "$($brew_cmd shellenv)"
else
  echo "WARN: brew not found ($brew_cmd)"
fi

if [ -x "$(command -v nvim)" ]; then
  export EDITOR="nvim"
fi

if [ -x "$(command -v R)" ]; then
  export R_PROFILE_USER="$XDG_CONFIG_HOME/R/Rprofile"
  export R_ENVIRON_USER="$XDG_CONFIG_HOME/R/Renviron"
else
  if [ -z "$IGNORE_UNINSTALLED_ALIAS" ]; then
    echo "INFO: R not installed"
  fi
fi

# Node via fnm (replaces nvm); guarded so a machine without fnm yet won't error.
# --log-level quiet keeps `fnm env`'s "Using Node vX" off stderr during zsh init (it
# applies the local .nvmrc itself and logs about it), which would otherwise trip
# Powerlevel10k's instant-prompt warning. `fnm env` exports FNM_LOGLEVEL=quiet, so
# restore info afterwards to keep the on-cd announcement from its chpwd hook.
if [ -x "$(command -v fnm)" ]; then
  eval "$(fnm env --use-on-cd --log-level quiet)"
  export FNM_LOGLEVEL=info
fi

export PATH="$XDG_DATA_HOME/bin:$PATH"

export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"

export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
export PATH="$HOME/.gem/ruby/$(ruby --version | cut -d' ' -f2 | cut -d'.' -f1,2).0/bin:$PATH"
export PATH="/opt/homebrew/opt/rustup/bin:$PATH"

export CLAUDE_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/claude"

# Private tokens (git-ignored) — absent on a fresh machine, so guard the source.
[ -f "$XDG_CONFIG_HOME/shell/exports_private.sh" ] && . "$XDG_CONFIG_HOME/shell/exports_private.sh"


