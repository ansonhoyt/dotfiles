# Anson's dotfiles

Informed by https://dotfiles.github.io/

Having a Git repo in your home folder doesn't work very well, so we keep this in `~/dotfiles` and symlink things in using [GNU Stow](https://www.gnu.org/software/stow/).

# Setup

Uses [GNU Stow](https://www.gnu.org/software/stow/) to avoid a Git repo in your home folder.

    brew install stow

    cd ~
    git clone git@bitbucket.org:ansonhoyt/dotfiles.git
    ls ~/dotfiles

Apply the configs

    ./dotfiles/install

Run the Brewfile

    brew tap homebrew/bundle
    brew bundle

# TODO

* Don't make my home folder into a Git repo

  Clone into existing folder without losing anything https://stackoverflow.com/questions/2411031/how-do-i-clone-into-a-non-empty-directory

# WIP

* https://github.com/xero/dotfiles uses GNU Stow
  * `brew install stow`
    stow 2.2.2 released Nov 2015
