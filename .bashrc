# Interactive shell configuration (also sourced by login shells)

# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# Warn if using old system bash (completions require bash 4.1+)
if [[ ${BASH_VERSINFO[0]} -lt 4 ]]; then
  echo "⚠️ Using system bash ${BASH_VERSION} - completions won't work"
  echo "   Fix:"
  echo "     '/opt/homebrew/bin/bash' | sudo tee -a /etc/shells && chsh -s /opt/homebrew/bin/bash"
fi

# Login shells already loaded these in .bash_profile. Non-login shells may
# start from a GUI app without inheriting a login shell's environment.
if ! shopt -q login_shell; then
  source ~/.bash/env.sh
  source ~/.bash/android.sh
fi

# Load interactive Bash configuration
source ~/.bash/options.sh
source ~/.bash/aliases.sh
source ~/.bash/completions.sh
source ~/.bash/functions.sh
source ~/.bash/prompt.sh
source ~/.bash/init.sh
