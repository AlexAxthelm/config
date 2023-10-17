#! /bin/sh
#
# Aliases for the shell
# Set IGNORE_UNINSTALLED_ALIAS to any value to suppress info messages.

safe_alias()
# safe_alias foo "bar --xyz" will alias foo to "bar --xyz" if bar exists
{
  cmd=$(echo "$2" | awk '{print $1;}')
  if [ -x "$(command -v "$cmd")" ]; then
    alias '$1'='$2'
  else
    if [ -z "$IGNORE_UNINSTALLED_ALIAS" ]; then
      echo "INFO: '$2' not installed"
    fi
  fi
}

# alias la="ls -la"

# if [ -x "$(command -v lsd)" ]; then
#   alias ls="lsd"
# else
#   if [ -z "$IGNORE_UNINSTALLED_ALIAS" ]; then
#     echo "INFO: lsd not installed"
#   fi
# fi

# if [ -x "$(command -v lsd)" ]; then
#   alias ls="lsd"
# else
#   if [ -z "$IGNORE_UNINSTALLED_ALIAS" ]; then
#     echo "INFO: lsd not installed"
#   fi
# fi


# if [ -x "$(command -v nvim)" ]; then
#   alias vim="nvim"
# else
#   echo "INFO: nvim not installed"
# fi

# if [ -x "$(command -v pip3)" ]; then
#   alias pip="pip3"
# else
#   echo "INFO: pip3 not installed"
# fi

# if [ -x "$(command -v bat)" ]; then
#   alias cat="bat"
# else
#   echo "INFO: bat not installed"
# fi
