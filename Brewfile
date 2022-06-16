# See https://robots.thoughtbot.com/brewfile-a-gemfile-but-for-homebrew
#
# Create a Brewfile:
#     brew bundle dump # of all existing packages
#     brew leaves # ...compare with list that doesn't include dependencies
#
# Usage:
#     brew bundle --help
#     brew bundle --global # install this Brewfile

# Taps (https://docs.brew.sh/brew-tap.html)
# tap 'caskroom/cask' # https://caskroom.github.io/
# tap 'caskroom/versions' # https://github.com/caskroom/homebrew-versions

# Homebrew
# (from `brew leaves`)

brew 'autojump' # `j` command for fast filesystem navigation
brew 'chromedriver' # for headless Selenium testing
brew 'cowsay'
# brew 'dnsmasq' # DNS server. Reads /usr/local/etc/dnsmasq.conf
brew 'git'
brew 'git-lfs'
brew 'gpg'
brew 'graphviz'
brew 'gnupg'
brew 'gron' # Make JSON greppable
# brew 'highlight'
brew 'jq' # JSON processor
brew 'mas'
# brew 'mitmproxy'
# brew 'nginx'
brew 'nethack'
brew 'openssl'
brew 'ripgrep'
brew 'ripgrep-all' # ripgrep, but also search in PDFs, E-Books, Office documents, zip, tar.gz, etc.
brew 'rogue'
# brew 'rsyslog'
brew 'ssh-copy-id'
brew 'stow' # Organize software neatly under a single directory tree
brew 'tmux' # Terminal multiplexer
brew 'tree'
brew 'wget'
brew 'yarn'

brew 'gibo' # https://github.com/simonwhitaker/gibo, https://github.com/github/gitignore

## Performance
brew 'htop'
brew 'lnav'
cask 'pingplotter'
brew 'iperf'
brew 'iperf3'

tap 'teamookla/speedtest'
brew 'teamookla/speedtest/speedtest'
mas 'Speedtest', id: 1153157709

## Editors
cask 'android-studio'
cask 'atom'
brew 'macvim'

## Frameworks
cask 'dotnet-sdk'
# cask 'java'
brew 'node' # TODO: drop since we use nvm?

# tap "adoptopenjdk/openjdk" # TODO: officially deprecated.
# cask "adoptopenjdk12"

## Databases
cask 'dbeaver-community'
# tap 'microsoft/mssql-release'
# brew 'microsoft/mssql-release/mssql-tools'
# brew 'mysql'
# cask 'mysqlworkbench'
cask 'pgadmin4'
brew 'postgresql'
# brew 'postgresql@9.4'
brew 'redis'
brew 'sqlite'

## Media
cask 'blender' # 3D creation suite
brew 'faac' # AAC audio encoder
brew 'ffmpeg'
brew 'ghostscript'
# cask 'gimp'
cask 'handbrake'
brew 'imagemagick'
cask 'inkscape'
cask 'jellyfin' # media system
brew 'makemkv' # video transcoder
brew 'metaz' # mp4 meta-data editor
cask 'obs' # live streaming and screen recording
brew 'pandoc' # Swiss-army knife of markup format conversion
mas 'Pixelmator', id: 407963104
mas 'Pixelmator Pro', id: 1289583905
brew 'sox' # SOund eXchange: universal sound sample translator
cask 'vlc' # media player

## Shell
brew 'bash-completion'
brew 'bundler-completion'
brew 'docker-completion'
brew 'gem-completion'
brew 'rails-completion'
brew 'rake-completion'
brew 'ruby-completion'
brew 'vagrant-completion'

## Raspberry Pi
cask 'balenaetcher'
cask 'raspberry-pi-imager'
# cask 'sdformatter'
cask 'vnc-viewer'

# Mac App Store
# (ids from `mas list`)

mas 'Amphetamine', id: 937984704
mas 'Bitwarden', id: 1352778147
mas 'LastPass', id: 926036361
mas 'Mactracker', id: 430255202
mas 'Xcode', id: 497799835

mas 'iMovie', id: 408981434
mas 'Keynote', id: 409183694
mas 'Kindle', id: 405399194
mas 'GarageBand', id: 682658836
mas 'Microsoft OneNote', id: 784801555
mas 'Microsoft Remote Desktop', id: 1295203466
mas 'Numbers', id: 409203825
mas 'Pages', id: 409201541
mas 'Playgrounds', id: 1496833156
mas 'Transporter', id: 1450874784
mas 'TweetDeck', id: 485812721

# Cask

# cask 'firefox'
# cask 'google-chrome'
cask 'iterm2'
cask 'keycastr'
cask 'microsoft-auto-update'
cask 'microsoft-edge'
cask 'rectangle'
# cask 'sketchup'
cask 'sonic-pi'
cask 'sourcetree'
cask 'superduper'
# cask 'transmission'
cask 'virtualbox-extension-pack' unless `uname -p` == 'arm'
cask 'virtualbox' unless `uname -p` == 'arm'
