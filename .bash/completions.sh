# Use Bash Completions
#
# Completions are found in `brew --prefix`/etc/bash_completion.d
#
# See https://docs.brew.sh/Shell-Completion

if type brew &>/dev/null; then
  source "$HOMEBREW_PREFIX/etc/bash_completion"
else
  echo "run: brew install git bash-completion"
fi
