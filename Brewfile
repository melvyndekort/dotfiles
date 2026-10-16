# macOS packages, installed with: brew bundle install --file="$(chezmoi source-path)/Brewfile"
# This file is deliberately ignored by chezmoi (see .chezmoiignore); it is not a dotfile.
# Bootstrap order is documented in CLAUDE.md.

# ==============================================================================
# SHELL & TERMINAL
# ==============================================================================

# Shell
brew "zsh"
brew "starship"
brew "direnv"
brew "zoxide"

# Terminal multiplexer and fuzzy finder
brew "tmux"
brew "fzf"

# Terminal emulator
cask "kitty"
cask "ghostty"

# Text editors and file navigation
brew "neovim"
brew "yazi"

# Command-line productivity
brew "bat"
brew "eza"
brew "fd"
brew "ripgrep"
brew "tree"
brew "tig"
brew "tldr"
brew "hexyl"

# System information and terminal decoration
brew "fastfetch"
brew "figlet"


# ==============================================================================
# DEVELOPMENT
# ==============================================================================

# Version control
brew "git"
brew "gh"
brew "git-delta" # git pager, see dot_config/git/config.tmpl

# Python development
brew "uv"
brew "ruff"

# Java development
brew "openjdk"
brew "maven"
cask "corretto@25"

# AI coding assistants
cask "claude-code"
cask "kiro-cli"

# Editors and IDEs
cask "vscodium"
cask "sublime-text"

# Android development
brew "android-platform-tools"


# ==============================================================================
# CLOUD INFRASTRUCTURE & DEVOPS
# ==============================================================================

# AWS CLI and authentication
brew "awscli"
brew "granted"
brew "docker-credential-helper-ecr"
cask "session-manager-plugin"

# Terraform and infrastructure as code
brew "tfenv"
brew "tflint"
brew "checkov"

# Containers and virtual machines
brew "podman"
brew "podman-compose"
brew "lima"
cask "utm"

# CI/CD and pipeline validation
brew "actionlint"

# Secret scanning
brew "gitleaks"

# Configuration management
brew "ansible"
brew "chezmoi"


# ==============================================================================
# SECURITY & CREDENTIAL MANAGEMENT
# ==============================================================================

# Password managers
brew "pass"
brew "bitwarden-cli"
cask "bitwarden"

# GPG and hardware security keys
brew "gnupg"
brew "pinentry-mac" # referenced by private_dot_gnupg/gpg-agent.conf.tmpl
brew "ykman"
cask "yubico-authenticator"

# Secure remote access and network diagnostics
brew "openssh"
brew "nmap"
cask "cloudflare-warp"

# Optional: test native macOS Keychain integration first
# brew "keychain"

# Optional / undecided (verify the name with `brew search` before enabling):
# cask "meld"                      # git diff.tool
# tap "nikitabobko/tap"
# cask "nikitabobko/tap/aerospace" # i3-like tiling WM, no SIP changes needed
# brew "docker"                    # not needed: the zshrc aliases docker to podman on macOS


# ==============================================================================
# NETWORKING, APIS & DATABASES
# ==============================================================================

# HTTP clients and API testing
brew "httpie"
cask "bruno"

# JSON processing
brew "jq"

# Database management
cask "dbvisualizer"


# ==============================================================================
# FILE MANAGEMENT & SYNCHRONIZATION
# ==============================================================================

# File synchronization and transfer
brew "syncthing", restart_service: true
brew "rsync"

# Archive management and compression
brew "sevenzip"
brew "unrar"
brew "unzip"
brew "zip"


# ==============================================================================
# MEDIA & DOCUMENT PROCESSING
# ==============================================================================

# Audio and video playback
brew "mpv"
brew "ffmpeg"
cask "spotify"
cask "kodi"

# Image editing and processing
brew "imagemagick"
cask "gimp"

# PDF processing
brew "pdftk-java"
cask "mupdf"


# ==============================================================================
# COMMUNICATION & COLLABORATION
# ==============================================================================

# Business communication
cask "microsoft-teams"
cask "slack"

# Messaging
cask "signal"

# IRC
brew "irssi"


# ==============================================================================
# WEB BROWSERS
# ==============================================================================

cask "firefox"
cask "chromium"


# ==============================================================================
# PRODUCTIVITY & KNOWLEDGE MANAGEMENT
# ==============================================================================

# Notes and documentation
cask "obsidian"

# Office applications
cask "microsoft-office"


# ==============================================================================
# REMOTE ACCESS & SUPPORT
# ==============================================================================

cask "rustdesk"


# ==============================================================================
# FONTS & TYPOGRAPHY
# ==============================================================================

# Monospace fonts
cask "font-hack"
cask "font-jetbrains-mono"

# General-purpose fonts
cask "font-dejavu"
cask "font-liberation"
cask "font-noto-sans"
cask "font-noto-sans-cjk"

# Symbols and emoji
cask "font-noto-color-emoji"
cask "font-symbols-only-nerd-font"