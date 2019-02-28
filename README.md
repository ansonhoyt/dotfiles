# Anson's dotfiles

Informed by https://dotfiles.github.io/

Having a Git repo in your home folder doesn't work very well, so we clone this into `~/dotfiles` and symlink into home with [GNU Stow](https://www.gnu.org/software/stow/).

# Setup

Pull in the dotfiles

    cd ~
    git clone git@bitbucket.org:ansonhoyt/dotfiles.git

Install [GNU Stow](https://www.gnu.org/software/stow/) and bash-completion

    brew install stow bash-completion

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

# tmux

    tmux new -n <session-name> # create a new session with a name
    tmux a -t <session-name>   # open the named session

# TODO

* Consider https://github.com/Bash-it/bash-it
* Consider replacing terminal codes in prompt with variables as in https://github.com/mathiasbynens/dotfiles/blob/master/.bash_prompt
* Check out https://news.ycombinator.com/item?id=18896422
* Consider [Dotfile madness](https://0x46.net/thoughts/2019/02/01/dotfile-madness/) discussed on [HN](https://news.ycombinator.com/item?id=19063727)
