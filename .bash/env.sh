# XDG Base Directory
export XDG_CONFIG_HOME="$HOME/.config"

# User bins (for my scripts and pipx tools)
export PATH=~/bin:$HOME/.local/bin:$PATH

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

# Yarn global bin
# - https://classic.yarnpkg.com/en/docs/cli/global/
# export PATH="$(yarn global bin):$PATH"
export PATH="$HOME/.yarn/bin:$PATH"

# Workaround for macOS fork() crashes in Ruby & Python (multiprocessing, app servers)
#   objc[97005]: +[NSValue initialize] may have been in progress in another thread when fork() was called.
# Ruby: https://blog.phusion.nl/2017/10/13/why-ruby-app-servers-break-on-macos-high-sierra-and-what-can-be-done-about-it/
# Python <3.8: https://github.com/python/cpython/issues/77906
#   (defaults to spawn since 3.8)
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

# Added by Obsidian
export PATH="$PATH:/Applications/Obsidian.app/Contents/MacOS"

# Added by LM Studio CLI (lms)
export PATH="$PATH:$HOME/.lmstudio/bin"
# End of LM Studio CLI section
