# grep colors
# 'auto' shows colors unless output is piped or redirected
alias grep='grep --color=auto'

# Launch VLC
alias vlc="open /Applications/VLC.app"

# Lock screen (macOS)
test `uname` == 'Darwin' && alias lock='pmset displaysleepnow'

# List RSpec tests
alias rlist="rspec --format documentation --color --dry-run"

# Alternative since Ruby 3.1+ syntax_tree also provides stree
alias sourcetree="$HOMEBREW_PREFIX/bin/stree"

# https://twitter.com/bsilva96/status/1802771491534033302
alias rspec-diff='bundle exec rspec $(git diff --name-only --diff-filter=d | grep "_spec.rb")'

alias bug='brew upgrade --greedy'

# File system
alias ls='eza -lh --group-directories-first --icons=auto'
alias lsa='ls -a'
alias lt='eza --tree --level=2 --long --icons --git'
alias lta='lt -a'
alias ff='fzf --preview "bat --style=numbers --color=always {}"'
alias nf='nvim $(fzf -m --preview="bat --color=always {}")'

# Directories
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Tools
alias d='docker'
alias r='rails'
n() { if [ "$#" -eq 0 ]; then nvim .; else nvim "$@"; fi; }

# Git
alias g='git'
alias gcm='git commit -m'
alias gcam='git commit -a -m'
alias gcad='git commit -a --amend'
