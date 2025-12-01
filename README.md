# Anson's dotfiles

Informed by <https://dotfiles.github.io/>

Having a Git repo in your home folder doesn't work very well, so we clone this into `~/dotfiles` and symlink into home with [GNU Stow](https://www.gnu.org/software/stow/).

# Setup

Clone and bootstrap:

```sh
git clone git@bitbucket.org:ansonhoyt/dotfiles.git ~/dotfiles
cd ~/dotfiles
./bootstrap.sh
```

Bootstrap handles:

- Homebrew installation (if needed)
- GNU Stow installation (if needed)
- Directory creation (`~/.ssh/sockets`)
- Stow (symlinking dotfiles to home)

Optional next steps:

```sh
brew bundle --global # Install Homebrew packages
./.osx               # Configure macOS defaults
```

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

* Add nvim-cmp for LSP autocompletion (`hrsh7th/nvim-cmp`, `hrsh7th/cmp-nvim-lsp`, `L3MON4D3/LuaSnip`)
* Consider https://github.com/Bash-it/bash-it
* Consider replacing terminal codes in prompt with variables as in https://github.com/mathiasbynens/dotfiles/blob/master/.bash_prompt
* Check out https://news.ycombinator.com/item?id=18896422
* Consider [Dotfile madness](https://0x46.net/thoughts/2019/02/01/dotfile-madness/) discussed on [HN](https://news.ycombinator.com/item?id=19063727)
