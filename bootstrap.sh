#!/usr/bin/env bash
# Bootstrap script to setup dependencies and stow dotfiles.

set -e  # Exit on error

echo "Setting up dotfiles..."
echo ""

# Install Homebrew if missing
if ! command -v brew &> /dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
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

# Create SSH sockets directory for connection multiplexing
mkdir -p ~/.ssh/sockets
chmod 700 ~/.ssh/sockets

# Stow dotfiles
echo "Stowing dotfiles..."
stow --verbose --restow .

# Install Homebrew packages
echo "Installing Homebrew packages..."
brew bundle --global

echo ""
echo "✓ Dotfiles setup complete"
echo ""
echo "Next steps:"
echo "  1. Set Homebrew bash as default shell:"
echo "       sudo sh -c 'echo /opt/homebrew/bin/bash >> /etc/shells'"
echo "       chsh -s /opt/homebrew/bin/bash"
echo "  2. Configure macOS defaults: ./.osx"
echo "  3. (Optional, multi-user Macs) Install Logi Options+ FUS switcher:"
echo "       ./system/logi-switch/install.sh"
