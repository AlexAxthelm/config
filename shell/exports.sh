#! /bin/sh
# Description: Export environment variables

# Don't use images for M1 Mac, since I'm mosly targeting Linux servers
export DOCKER_DEFAULT_PLATFORM="linux/amd64"

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

if [ -x "$(command -v R)" ]; then
  export R_PROFILE_USER="$XDG_CONFIG_HOME/R/Rprofile"
  export R_ENVIRON_USER="$XDG_CONFIG_HOME/R/Renviron"
else
  if [ -z "$IGNORE_UNINSTALLED_ALIAS" ]; then
    echo "INFO: R not installed"
  fi
fi

