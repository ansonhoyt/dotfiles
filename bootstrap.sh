#!/usr/bin/env bash
# Bootstrap script to setup dependencies and stow dotfiles.

set -e -o pipefail  # Exit on error, including failures early in a pipeline

# Relative paths below (stow ., .claude/settings.json) need the repo root
cd "$(dirname "$0")" || exit

echo "Setting up dotfiles..."
echo ""

# Install Homebrew if missing
if ! command -v brew &> /dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # Installer can't modify this shell's PATH — add brew (arm64 or intel)
  eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv)"
else
  echo "✓ Homebrew already installed"
fi

# Install stow if missing
if ! command -v stow &> /dev/null; then
  echo "Installing stow..."
  brew install stow
else
  echo "✓ stow already installed"
fi

echo ""

# Prevent stow from "tree folding" runtime dirs into dotfiles
mkdir -p ~/.claude

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
brew bundle --global

# Install mise-managed runtimes and CLIs (node, ruby, npm tools).
# Needs mise (from brew bundle above) and ~/.config/mise/config.toml
# (stowed above). Postinstall hooks sync agent skills and install
# git hooks — see .config/mise/config.toml.
echo ""
echo "Installing mise-managed tools..."
mise install

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
