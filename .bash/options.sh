# Interactive shell options

# Display command time when viewing history
#   "<number> Apr 27 3:45 PM <command>"
# See `history help; man strftime;`
export HISTTIMEFORMAT="%b %d %H:%M %p  "

shopt -s histappend
export HISTCONTROL=ignoreboth # ignorespace + ignoredups
export HISTSIZE=32768
export HISTFILESIZE="${HISTSIZE}"

# Raise per-process file descriptor limit. macOS default (256) is too low for
# modern dev tooling (watchers, esbuild, lazygit subprocess fan-out, etc.) and
# manifests as silent hangs rather than EMFILE errors.
# https://github.com/facebook/watchman/blob/main/website/docs/install.md
ulimit -n 65536
