# Login shell configuration
#
# Bash looks for these in order, and runs the first available of:
#   .bash_profile, .bash_login, .profile
# - https://www.gnu.org/software/bash/manual/bashref.html#Bash-Startup-Files

# Homebrew
if [[ $(uname -p) == "arm" ]]; then # Apple Silicon
  eval "$(/opt/homebrew/bin/brew shellenv)"
  alias ibrew="arch -x86_64 /usr/local/bin/brew" # brew for Intel x86
else # Intel x86
  eval "$(/usr/local/bin/brew shellenv)"
fi

# mise shims for non-interactive shells (IDEs, Claude Code, scripts, etc.)
# https://mise.jdx.dev/ide-integration.html#adding-shims-to-path-default-shell
eval "$(mise activate bash --shims)"

# Also apply the interactive shell config:
if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi
