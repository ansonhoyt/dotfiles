# Default editor (git, etc.)
export EDITOR=vim

# Rails better_errors editor
# https://github.com/BetterErrors/better_errors/wiki/Link-to-your-editor
export BETTER_ERRORS_EDITOR='code --wait'

# Bundle editor, used for `bundle open <gem_name>`
export BUNDLER_EDITOR=code

# Ansible uses cowsay too much for my taste.
export ANSIBLE_NOCOWS=1

# gdal2 commands, per `brew info osgeo/osgeo4mac/gdal2`
export PATH="$HOMEBREW_PREFIX/opt/gdal2/bin:$PATH"

# gdal2-python, per  `brew info osgeo/osgeo4mac/gdal2-python`
# export PATH="$HOMEBREW_PREFIX/opt/gdal2-python/bin:$PATH"

# Display command time when viewing history
#   "<number> Apr 27 3:45 PM <command>"
# See `history help; man strftime;`
export HISTTIMEFORMAT="%b %d %H:%M %p  "
