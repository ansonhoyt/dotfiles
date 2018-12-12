# Anson's dotfiles

Informed by https://dotfiles.github.io/

Having a Git repo in your home folder doesn't work very well, so we clone this into `~/dotfiles` and symlink into home with [GNU Stow](https://www.gnu.org/software/stow/).

# Setup

Pull in the dotfiles

    cd ~
    git clone git@bitbucket.org:ansonhoyt/dotfiles.git

Install [GNU Stow](https://www.gnu.org/software/stow/)

    brew install stow

Preview, then apply the configs

    cd ~/dotfiles
    stow --no --verbose=2 .
    stow --verbose .

...ignore existing files to preserve local edits or restow to clear stale symlinks. See `man stow`.

    stow --no --verbose=2 --ignore=".gitconfig" .
    stow --no --verbose=2 --restow .

Run the Brewfile to install some tools

    brew tap homebrew/bundle
    brew bundle

# TODO

* DRY up completions.sh
* Consider https://github.com/Bash-it/bash-it
