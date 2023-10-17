#! /bin/sh
# Description: Export environment variables

# Don't use images for M1 Mac, since I'm mosly targeting Linux servers
export DOCKER_DEFAULT_PLATFORM="linux/amd64"

# Powerline Settings
export POWERLINE_REPOSITORY_ROOT="/opt/homebrew/lib/python3.11/site-packages"

# Homebrew
if [ -x "$(command -v brew)" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
