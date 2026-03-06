# Interactive shell configuration (not a login shell)

# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# Warn if using old system bash (completions require bash 4.1+)
if [[ ${BASH_VERSINFO[0]} -lt 4 ]]; then
  echo "⚠️ Using system bash ${BASH_VERSION} - completions won't work"
  echo "   Fix:"
  echo "     '/opt/homebrew/bin/bash' | sudo tee -a /etc/shells && chsh -s /opt/homebrew/bin/bash"
fi

# Homebrew
if [[ $(uname -p) == "arm" ]]; then # Apple Silicon
  eval "$(/opt/homebrew/bin/brew shellenv)"
  alias ibrew="arch -x86_64 /usr/local/bin/brew" # brew for Intel x86
else # Intel x86
  eval "$(/usr/local/bin/brew shellenv)"
fi

# Load Bash configuration (order matters: env sets PATH before tools init)
source ~/.bash/env.sh
source ~/.bash/aliases.sh
source ~/.bash/completions.sh
source ~/.bash/functions.sh
source ~/.bash/prompt.sh
source ~/.bash/init.sh
