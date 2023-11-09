#! /bin/bash

# https://github.com/chriskempson/base16-shell

# Base16 Shell
BASE16_SHELL="$XDG_CACHE_HOME/base16-shell"

if [ ! -d "$BASE16_SHELL" ]; then
  echo "Cloning base-16-shell"
  git clone "git@github.com:chriskempson/base16-shell.git" "$BASE16_SHELL"
fi

[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
        source "$BASE16_SHELL/profile_helper.sh"
        

base16_solarized-dark
