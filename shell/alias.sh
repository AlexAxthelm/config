#! /bin/sh
#
# Aliases for the shell
# Set IGNORE_UNINSTALLED_ALIAS to any value to suppress info messages.

# navigation
alias ..='cd ..'
alias ...='cd ../../../'
alias ....='cd ../../../../'
alias .....='cd ../../../../'
alias .4='cd ../../../../'
alias .5='cd ../../../../..'

# History
alias h='history'
alias gh='history|grep'

# ls
alias la="ls -la"

# Applications
if [ -x "$(command -v lsd)" ]; then
  alias ls="lsd"
else
  if [ -z "$IGNORE_UNINSTALLED_ALIAS" ]; then
    echo "INFO: lsd not installed"
  fi
fi

if [ -x "$(command -v nvim)" ]; then
  alias vim="nvim"
else
  if [ -z "$IGNORE_UNINSTALLED_ALIAS" ]; then
    echo "INFO: nvim not installed"
  fi
fi

if [ -x "$(command -v pip3)" ]; then
  alias pip="pip3"
else
  if [ -z "$IGNORE_UNINSTALLED_ALIAS" ]; then
    echo "INFO: pip3 not installed"
  fi
fi

if [ -x "$(command -v bat)" ]; then
  alias cat="bat"
else
  if [ -z "$IGNORE_UNINSTALLED_ALIAS" ]; then
    echo "INFO: bat not installed"
  fi
fi

if [ -x "$(command -v R)" ]; then
  alias R="R --quiet"
else
  if [ -z "$IGNORE_UNINSTALLED_ALIAS" ]; then
    echo "INFO: R not installed"
  fi
fi

