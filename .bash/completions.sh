# Activate Bash Completions
#
# Homebrew seems to be installing them in `/usr/local/etc/bash_completion.d/`
# so we'll roll with that, despite many posts and packages with different instructions.
#
# Lots of conflicting instructions for setting these up:
# https://debian-administration.org/article/316/An_introduction_to_bash_completion_part_1
# https://github.com/scop/bash-completion (via `brew info bash-completion`)
#

if [ -f `brew --prefix`/etc/bash_completion.d/brew ]; then
  . `brew --prefix`/etc/bash_completion.d/brew
else
  echo "Missing bash completions for Homebrew"
fi

if [ -f `brew --prefix`/etc/bash_completion.d/gibo-completion.bash ]; then
  . `brew --prefix`/etc/bash_completion.d/gibo-completion.bash
else
  echo "Missing bash completions for gibo"
fi

# https://github.com/git/git/tree/master/contrib/completion
# https://github.com/bobthecow/git-flow-completion/issues/46
if [ -f `brew --prefix`/etc/bash_completion.d/git-completion.bash ]; then
  . `brew --prefix`/etc/bash_completion.d/git-completion.bash
else
  echo "Missing bash completions for git"
fi

if [ -f `brew --prefix`/etc/bash_completion.d/git-prompt.sh ]; then
  . `brew --prefix`/etc/bash_completion.d/git-prompt.sh
else
  echo "Missing bash completions for git-prompt"
fi

if [ -f `brew --prefix`/etc/bash_completion.d/npm ]; then
  . `brew --prefix`/etc/bash_completion.d/npm
else
  echo "Missing bash completions for npm"
fi

if [ -f `brew --prefix`/etc/bash_completion.d/rg.bash-completion ]; then
  . `brew --prefix`/etc/bash_completion.d/rg.bash-completion
else
  echo "Missing bash completions for ripgrep"
fi
