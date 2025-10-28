# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal dotfiles repository for macOS, managed with GNU Stow for symlinking configuration files from `~/dotfiles` into the home directory. The repository contains shell configurations, editor setups (Neovim, Vim), and various development tools configurations.

## Key Architecture

### GNU Stow Management

The entire repository is designed to be stowed from `~/dotfiles`:

```bash
# Preview what would be symlinked
stow --no --verbose=2 .

# Apply the configurations
stow --verbose .

# Ignore specific files if needed
stow --no --verbose=2 --ignore=".gitconfig|.DS_Store" .

# Restow to clear stale symlinks
stow --no --verbose=2 --restow .
```

Files listed in `.stow-local-ignore` are automatically excluded from symlinking (includes `.git`, README, LICENSE, `.DS_Store`, and markdown files).

### Bash Configuration Loading Order

1. **`.bash_profile`** (login shells) - sources `.bashrc`
2. **`.bashrc`** (interactive shells) - Sets up:
   - SSH agent initialization
   - Homebrew environment (with Apple Silicon vs Intel detection)
   - Loads all files from `~/.bash/*.sh` (aliases, functions, completions, etc.)
   - Configures NVM, Yarn, RVM
   - Adds `~/bin` to PATH
3. **`.bash/init.sh`** - Initializes modern CLI tools (fzf, mise, zoxide, starship)

Key bash modules in `.bash/`:
- `aliases.sh` - Command shortcuts, modern replacements (eza for ls, zoxide for cd)
- `functions.sh` - Utility functions (authorize, listening)
- `completions.sh` - Shell completions
- `env.sh` - Environment variables
- `prompt.sh` - Prompt configuration (overridden by starship)

### Configuration Structure

```
.
├── .bash/              # Modular bash configuration loaded by .bashrc
├── .config/            # XDG-style configs
│   ├── git/           # Git config, ignore, attributes
│   ├── nvim/          # Neovim (lazy.nvim setup)
│   ├── lsp/           # LSP configurations
│   ├── starship.toml  # Prompt configuration
│   ├── mise/          # Runtime version manager
│   └── bat/           # bat (cat replacement) config
├── bin/                # User scripts (in PATH via .bashrc)
├── .inputrc           # Readline configuration
├── .osx               # macOS defaults script
├── Brewfile           # Homebrew packages/casks/apps
└── dotfiles in root   # Stowed directly to home (~)
```

### Tool Setup

**Package Management:**
- `Brewfile` - Comprehensive list of Homebrew packages, casks, and Mac App Store apps
- Install with: `brew bundle` (or `brew bundle --global`)

**Neovim:**
- Uses lazy.nvim plugin manager (not the full LazyVim distribution)
- Entry point: `init.lua` - minimal, just loads config.lazy
- Plugin manager setup: `lua/config/lazy.lua` - bootstrap, mapleader, loads options, then lazy.setup()
- Vim options: `lua/config/options.lua` - manually required by lazy.lua before plugins load
- Plugins: `lua/plugins/*.lua` - individual plugin specs
- LSP: ruby-lsp enabled in init.lua
- Leader key: Space
- Mouse enabled with system clipboard integration

**Version Managers:**
- **mise** - Replaces asdf/rbenv for Ruby and other runtimes
- **NVM** - Node version management (loaded in .bashrc)
- **RVM** - Ruby version management (loaded as function in .bashrc)

**Modern CLI Tools** (initialized in `.bash/init.sh`):
- **fzf** - Fuzzy finder with keybindings
- **zoxide** - Smart directory jumper (aliased to cd)
- **starship** - Cross-shell prompt
- **eza** - Modern ls replacement (aliased to ls)

## Common Commands

### Setup/Installation
```bash
# Install Homebrew packages
brew bundle

# Configure macOS defaults
./.osx

# Apply dotfiles with GNU Stow
cd ~/dotfiles
stow --verbose .
```

### Development Workflows

**Ruby/Rails:**
```bash
rlist                    # List RSpec tests with descriptions
rspec-diff              # Run specs for changed files
```

**File Navigation:**
```bash
ls                      # eza with icons and directories first
lt                      # Tree view (2 levels)
ff                      # fzf with bat preview
nf                      # Open file(s) in nvim with fzf picker
cd <fuzzy-path>         # zoxide smart jump
```

**Git Aliases:**
```bash
g                       # git
gcm "message"           # git commit -m
gcam "message"          # git commit -a -m
gcad                    # git commit -a --amend
```

**Useful Functions:**
```bash
authorize server.com    # Copy SSH key to remote host
listening [port]        # List processes on TCP ports
n [files]              # Open nvim (current dir if no args)
```

### Homebrew
```bash
bug                     # brew upgrade --greedy (alias)
brew bundle dump        # Generate Brewfile from installed packages
brew leaves             # List installed packages (no dependencies)
```

## Important Notes

- **Architecture Detection**: `.bashrc` detects Apple Silicon vs Intel and sets up Homebrew accordingly (`/opt/homebrew` vs `/usr/local`)
- **Ruby Configuration**: `rvm_docs_flag=1` ensures Ruby gems install with documentation
- **SSH Agent**: Automatically started and managed by `.bashrc`
- **Readline**: `.inputrc` configures case-insensitive completion, history search with arrow keys
- **Git**: Config in `.config/git/config` with aliases (co, br, ci, st) and pull.rebase=true
- **User Scripts**: Place custom scripts in `bin/` - automatically added to PATH

## Stow Ignore Patterns

When modifying `.stow-local-ignore`, note it uses regex patterns. Currently ignores:
- Version control directories (.git, .svn, etc.)
- Documentation (README, LICENSE, markdown files)
- Editor artifacts (backup files, autosave)
- macOS metadata (.DS_Store)
