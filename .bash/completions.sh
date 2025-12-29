# Use Bash Completions
#
# See `brew info bash-completion@2` and https://docs.brew.sh/Shell-Completion

if [[ -r "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh" ]]; then
  source "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh"
else
  echo "run: brew install bash-completion@2"
fi
