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
brew 'cowsay'
brew 'dnsmasq' # DNS server. Reads $HOMEBREW_PREFIX/etc/dnsmasq.conf
brew 'fortune' # Infamous electronic fortune-cookie generator
brew 'git'
brew 'git-lfs'
brew 'graphviz'
brew 'gnupg' # GNU Pretty Good Privacy (PGP)
brew 'highlight'
brew 'mas' # Mac App Store command-line interface
brew 'mitmproxy'
brew 'nginx'
brew 'nethack'
brew 'openssl'
brew 'p7zip' # 7-Zip (high compression file archiver)
brew 'ripgrep'
brew 'ripgrep-all' # ripgrep, but also search in PDFs, E-Books, Office documents, zip, tar.gz, etc.
brew 'rogue'
brew 'rsyslog'
brew 'ssh-copy-id'
brew 'stow' # Organize software neatly under a single directory tree
brew 'tmux' # Terminal multiplexer
brew 'tree'
brew 'wget'

brew 'gibo' # Access GitHub's .gitignore boilerplates, https://github.com/github/gitignore

## Performance
brew 'bench' # benchmarking, a more-powerful `time` command
brew 'dog' # Command-line DNS client
brew 'gdb'
brew 'htop'
# brew 'jmeter' # Load testing and performance measurement application
brew 'lnav'
# brew 'nmap' # Port scanning utility for large networks
# brew 'oha' # HTTP load generator
cask 'pingplotter'
brew 'iperf' # Tool to measure maximum TCP and UDP bandwidth
brew 'iperf3'

tap 'teamookla/speedtest'
brew 'teamookla/speedtest/speedtest'
mas 'Speedtest', id: 1153157709

## Editors
# cask 'atom'
brew 'macvim'
cask 'visual-studio-code'

## Frameworks
cask 'dotnet-sdk'
# cask 'java' # OpenJDK
# brew 'node' # TODO: drop since we use nvm?
brew 'python'

# brew 'yarn' # NOTE: installed via nvm => node => npm
brew 'gron' # Make JSON greppable
brew 'jq' # JSON processor
cask 'quicklook-json'

## React Native
cask 'android-studio'
cask 'react-native-debugger'
brew 'firebase-cli'

## Rails Active Storage dependencies
brew 'vips' # for image analysis and transformations
brew 'ffmpeg' # for video previews and ffprobe for video/audio analysis
brew 'mupdf' # PDF previews
brew 'poppler' # PDF previews

## Databases
cask 'dbeaver-community'
cask 'db-browser-for-sqlite'
# tap 'microsoft/mssql-release'
# brew 'microsoft/mssql-release/mssql-tools'
# brew 'freetds' # Libraries to talk to mssql
# brew 'mysql'
# cask 'mysqlworkbench'
cask 'pgadmin4'
brew 'postgresql'
brew 'redis'
brew 'sqlite'

## Media
cask 'blender' # 3D creation suite
brew 'faac' # AAC audio encoder
mas 'GarageBand', id: 682658836
brew 'ghostscript'
cask 'gimp'
cask 'handbrake'
brew 'imagemagick'
mas 'iMovie', id: 408981434
cask 'inkscape'
cask 'jellyfin' # media system
brew 'mad' # MPEG audio decoder
cask 'makemkv' # MakeMKV video transcoder
cask 'metaz' # Mp4 meta-data editor
cask 'obs' # live streaming and screen recording
brew 'pandoc' # Swiss-army knife of markup format conversion
# brew 'optipng' # PNG file optimizer
# brew 'pngcrush' # Optimizer for PNG files
# brew 'pngquant' # PNG image optimizing utility
# brew 'jonof/kenutils/pngout' # Ken Silverman's PNG optimisation utility
# brew 'optipng' # PNG file optimizer
# brew 'opencore-amr' # Audio codecs extracted from Android open source project
mas 'Pixelmator', id: 407963104
mas 'Pixelmator Pro', id: 1289583905
brew 'sox' # SOund eXchange: universal sound sample translator
cask 'vlc' # media player
brew 'youtube-dl' # Download YouTube videos from the command-line
# NOTE: Audacity should *not* be installed with Homebrew

## GIS
# brew 'proj' # Cartographic Projections Library
# brew 'qgis'

## Shell
cask 'iterm2'
brew 'fish'
brew 'bash-completion'
brew 'bundler-completion'
brew 'docker-completion'
brew 'gem-completion'
brew 'rails-completion'
brew 'rake-completion'
brew 'ruby-completion'
brew 'vagrant-completion'
brew 'yarn-completion'

## Raspberry Pi
cask 'balenaetcher'
cask 'raspberry-pi-imager'
# cask 'sdformatter'
cask 'vnc-viewer'

## Password Managers
cask 'authy' # Authy Desktop
mas 'Bitwarden', id: 1352778147
brew 'bitwarden-cli'
mas 'LastPass', id: 926036361

# Mac App Store
# (ids from `mas list`)

mas 'Amphetamine', id: 937984704
mas 'Mactracker', id: 430255202
mas 'Xcode', id: 497799835

mas 'Keynote', id: 409183694
mas 'Kindle', id: 405399194
mas 'Microsoft OneNote', id: 784801555
mas 'Microsoft Remote Desktop', id: 1295203466
mas 'Numbers', id: 409203825
mas 'Pages', id: 409201541
mas 'Playgrounds', id: 1496833156
mas 'Transporter', id: 1450874784
mas 'TweetDeck', id: 485812721

# Cask

cask 'calibre' # E-books management software
# cask 'chromedriver' # for headless Selenium testing # TODO: drop for webdrivers gem??? or is this de-dupish?
# cask 'firefox'
cask 'github' # GitHub Desktop
# cask 'google-chrome'
cask 'keycastr'
cask 'libreoffice'
cask 'microsoft-auto-update'
cask 'microsoft-edge'
cask 'rectangle'
cask 'scratch'
# cask 'sketchup'
cask 'sonic-pi'
cask 'sourcetree'
cask 'superduper'
# cask 'transmission-cli'
cask 'utm'
cask 'vagrant'

if Gem::Platform.local =~ 'x86_64-darwin'
  # NOTE: Unsupported on 'arm64-darwin'
  cask 'virtualbox-extension-pack'
  cask 'virtualbox'
end
