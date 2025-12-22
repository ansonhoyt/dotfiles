# XDG Base Directory
export XDG_CONFIG_HOME="$HOME/.config"

# Default editor (git, etc.)
if command -v nvim >/dev/null 2>&1; then
  export EDITOR=nvim
else
  export EDITOR=vim
fi

# Rails better_errors editor
# https://github.com/BetterErrors/better_errors/wiki/Link-to-your-editor
export BETTER_ERRORS_EDITOR='code --wait'

# Bundle editor, used for `bundle open <gem_name>`
export BUNDLER_EDITOR=code

# Ansible uses cowsay too much for my taste.
export ANSIBLE_NOCOWS=1

# Display command time when viewing history
#   "<number> Apr 27 3:45 PM <command>"
# See `history help; man strftime;`
export HISTTIMEFORMAT="%b %d %H:%M %p  "

shopt -s histappend
export HISTCONTROL=ignoreboth # ignorespace + ignoredups
export HISTSIZE=32768
export HISTFILESIZE="${HISTSIZE}"

# Setup 1Password SSH Agent communication with other processes.
# Needed so `ssh-add -l` sees identities.
# - https://developer.1password.com/docs/ssh/agent/
# - https://developer.1password.com/docs/ssh/get-started/#step-4-configure-your-ssh-or-git-client
# - https://blog.joncairns.com/2013/12/understanding-ssh-agent-and-ssh-add/
export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock
