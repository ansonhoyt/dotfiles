# Interactive, non-login shell configuration

# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# Warn if using old system bash (completions require bash 4.1+)
if [[ ${BASH_VERSINFO[0]} -lt 4 ]]; then
  echo "⚠️ Using system bash ${BASH_VERSION} - completions won't work"
  echo "   Fix:"
  echo "     '/opt/homebrew/bin/bash' | sudo tee -a /etc/shells && chsh -s /opt/homebrew/bin/bash"
fi

# Load Bash configuration (order matters: env sets PATH before tools init)
source ~/.bash/env.sh
source ~/.bash/aliases.sh
source ~/.bash/completions.sh
source ~/.bash/functions.sh
source ~/.bash/prompt.sh
source ~/.bash/init.sh
