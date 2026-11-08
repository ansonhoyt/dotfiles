#!/usr/bin/env bash
# Bootstrap script to setup dependencies and stow dotfiles.

set -e -o pipefail  # Exit on error, including failures early in a pipeline

# Relative paths below (stow ., .claude/settings.json) need the repo root
cd "$(dirname "$0")" || exit

echo "Setting up dotfiles..."
echo ""

# Brew may be installed but not on PATH (fresh terminal, default zsh, pre-chsh)
eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv 2>/dev/null || true)"

# Install Homebrew if missing
if command -v brew >/dev/null 2>&1; then
  echo "✓ Homebrew already installed"
else
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # Installer can't modify this shell's PATH; apply it for this run.
  eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv)"
fi

# Accept the Xcode license before future brew installs.
if [ -d /Applications/Xcode.app ] && ! xcodebuild -checkFirstLaunchStatus >/dev/null 2>&1; then
  sudo xcodebuild -runFirstLaunch
fi

# Install stow if missing
if ! command -v stow &> /dev/null; then
  echo "Installing stow..."
  brew install stow
else
  echo "✓ stow already installed"
fi

echo ""

# Store .claude/settings.json key-sorted; Claude Code rewrites it in unstable
# order (see .gitattributes). Filter config is per-clone, so set it here.
git config --local filter.jsonsort.clean 'jq -S .'
git config --local filter.jsonsort.smudge cat
git config --local filter.jsonsort.required true
git config --local diff.jsonsort.textconv 'jq -S .'

# Prevent stow from "tree folding" runtime dirs into dotfiles
mkdir -p ~/.agents
mkdir -p ~/.claude
mkdir -p ~/.codex
mkdir -p ~/.config/homebrew
mkdir -p ~/.config/herdr-app
mkdir -p ~/.config/opencode
mkdir -p ~/.config/tmux

# Ensure ~/.ssh exists with correct perms before stow
# (avoids tree-folding the whole dir into dotfiles/.ssh)
mkdir -p ~/.ssh && chmod 700 ~/.ssh

# SSH sockets directory for connection multiplexing
mkdir -p ~/.ssh/sockets && chmod 700 ~/.ssh/sockets

# Stow dotfiles
echo "Stowing dotfiles..."
stow --verbose --restow .

# Install Homebrew packages
echo "Installing Homebrew packages..."
brew bundle --global || echo "🔥 bundle failed, so will need re-run.... Continuing with remaining steps."

# Generate completions not supplied by the Homebrew packages (op, container).
echo "Generating shell completions..."
./bin/refresh-completions

# Install mise-managed runtimes and CLIs (node, ruby, npm tools).
# Needs mise (from brew bundle above) and ~/.config/mise/config.toml
# (stowed above). Postinstall hooks sync agent skills and bash
# completions and install git hooks — see .config/mise/config.toml.
echo ""
echo "Installing mise-managed tools..."
mise install

# OpenCode's browse MCP is stowed. Register missing Claude/Codex entries without
# overwriting custom servers. Do not use `browse install`: even with updates
# disabled, it installs a second, global npm copy that shadows mise's version.
echo ""
echo "Configuring mise-managed browse..."
if ! mise exec -- claude mcp get browse >/dev/null 2>&1; then
  mise exec -- claude mcp add browse --scope user --env OPENCODE_BROWSER_AUTO_UPDATE=notify -- mise exec -- browse mcp
fi
if ! mise exec -- codex mcp get browse >/dev/null 2>&1; then
  mise exec -- codex mcp add browse --env OPENCODE_BROWSER_AUTO_UPDATE=notify -- mise exec -- browse mcp
fi

# Start pitchfork's supervisor now and at login so global cron daemons such as
# qmd-refresh run (see .config/pitchfork/config.toml). Both are idempotent.
echo ""
echo "Starting pitchfork supervisor..."
mise exec -- pitchfork boot enable
mise exec -- pitchfork supervisor start

# Install tmux plugins. tmux.conf auto-clones TPM on first tmux launch,
# but plugin install normally needs an interactive `prefix + I`; TPM's CLI
# installer covers it here (idempotent, needs tmux + stowed tmux.conf).
echo ""
echo "Installing tmux plugins..."
if [ ! -d ~/.config/tmux/plugins/tpm ]; then
  git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
fi
~/.config/tmux/plugins/tpm/bin/install_plugins

# Sync Claude Code plugins declared in .claude/settings.json
# (marketplace add / plugin install are idempotent no-ops if already present)
echo ""
echo "Syncing Claude Code plugins..."
jq -r '.extraKnownMarketplaces // {} | to_entries[] | .value.source.repo // .value.source.url // .value.source.path' .claude/settings.json | while read -r source; do
  claude plugin marketplace add "$source"
done
jq -r '.enabledPlugins // {} | to_entries[] | select(.value == true) | .key' .claude/settings.json | while read -r plugin; do
  claude plugin install "$plugin"
done

echo ""

# No 1Password CLI/API to enable this (GUI toggle only), and commit signing
# (op-ssh-sign) fails silently without it, so warn.
if [ ! -S ~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock ]; then
  echo "⚠️  1Password SSH Agent not detected — git commit signing will fail until enabled:"
  echo "    1Password → Settings → Developer → check 'Use the SSH Agent'"
  echo ""
fi

echo "✓ Dotfiles setup complete"
echo ""
echo "Next steps:"
echo "  1. Set Homebrew bash as default shell:"
echo "       sudo sh -c 'echo $(brew --prefix)/bin/bash >> /etc/shells'"
echo "       chsh -s $(brew --prefix)/bin/bash"
echo "  2. Configure macOS defaults: ./.osx"
echo "  3. Raise GUI FD limits (fixes silent app hangs):"
echo "       ./system/maxfiles/install.sh"
echo "  4. (Optional, multi-user Macs) Install Logi Options+ FUS switcher:"
echo "       ./system/logi-switch/install.sh"
echo "  5. Install the browse Chrome extension, then pair it:"
echo "       mise exec -- browse pair"
