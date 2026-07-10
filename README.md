# Anson's dotfiles

Informed by <https://dotfiles.github.io/>

Having a Git repo in your home folder doesn't work very well, so we clone this into `~/dotfiles` and symlink into home with [GNU Stow](https://www.gnu.org/software/stow/).

# Setup

Clone and bootstrap:

```sh
xcode-select --install # for git
git clone https://github.com/ansonhoyt/dotfiles.git ~/dotfiles
cd ~/dotfiles
./bootstrap.sh
```

Bootstrap handles:

- Homebrew + packages (`brew bundle --global`)
- GNU Stow installation and stowing (symlinking dotfiles to home)
- mise runtimes and CLIs (`mise install` — postinstall hooks add git hooks and agent skills)
- Claude Code plugin sync

When done it prints the remaining manual steps.

## [Stow](https://www.gnu.org/software/stow/)

See `man stow`. For ignored files see `.stow-local-ignore`.

Useful commands:

```sh
stow --no --verbose=2 .          # Preview changes
stow --verbose --restow .        # Reapply (clears stale symlinks)
```

# tmux

See <https://tmuxcheatsheet.com/>

    tmux new -n <session-name>  # create a new session with a name
    Ctrl + b d                  # detach from the current session
    tmux ls                     # list all sessions
    tmux a -t <session-name>    # attach the named session

# TODO

- Consider <https://github.com/Bash-it/bash-it>
- Check out <https://news.ycombinator.com/item?id=18896422>
- Consider [Dotfile madness](https://0x46.net/thoughts/2019/02/01/dotfile-madness/) discussed on [HN](https://news.ycombinator.com/item?id=19063727)
