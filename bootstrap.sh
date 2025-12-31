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

# Create necessary directories
echo "Creating ~/.ssh/sockets for SSH connection multiplexing..."
mkdir -p ~/.ssh/sockets
chmod 700 ~/.ssh/sockets

# Stow dotfiles
echo "Stowing dotfiles..."
stow --verbose --restow .

echo ""
echo "✓ Dotfiles setup complete"
echo ""
echo "Next steps:"
echo "  1. Install Homebrew packages: brew bundle --global"
echo "  2. Set Homebrew bash as default shell:"
echo "       sudo sh -c 'echo /opt/homebrew/bin/bash >> /etc/shells'"
echo "       chsh -s /opt/homebrew/bin/bash"
echo "  3. Configure macOS defaults: ./.osx"
