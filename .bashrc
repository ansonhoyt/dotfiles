# Loaded for interactive non-login shells

# Homebrew
if [[ $(uname -p) == "arm" ]]; then # Apple Silicon
  eval "$(/opt/homebrew/bin/brew shellenv)"
  alias ibrew="arch -x86_64 /usr/local/bin/brew" # brew for Intel x86
else # Intel x86
  eval "$(/usr/local/bin/brew shellenv)"
fi

# Load all Bash configuration files from ~/.bash/*.sh
# NOTE: *after* Homebrew since brews are used in several
for bash_config in ~/.bash/*.sh; do source $bash_config; done

# User bins (for my scripts and pipx tools)
export PATH=~/bin:$HOME/.local/bin:$PATH

# Yarn global bin
# - https://classic.yarnpkg.com/en/docs/cli/global/
# export PATH="$(yarn global bin):$PATH"
export PATH="$HOME/.yarn/bin:$PATH"

# Load RVM into a shell session *as a function*
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
[[ -d "$HOME/.rvm/bin" ]] && export PATH="$PATH:$HOME/.rvm/bin"

# Always install Ruby with documentation
export rvm_docs_flag=1

# Workaround for macOS fork() crashes in Ruby & Python (multiprocessing, app servers)
#   objc[97005]: +[NSValue initialize] may have been in progress in another thread when fork() was called.
# Ruby: https://blog.phusion.nl/2017/10/13/why-ruby-app-servers-break-on-macos-high-sierra-and-what-can-be-done-about-it/
# Python <3.8: https://github.com/python/cpython/issues/77906
#   (defaults to spawn since 3.8)
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

# https://github.com/ajeetdsouza/zoxide
eval "$(zoxide init bash --cmd cd)"

