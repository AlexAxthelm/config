# Brewfile — curated for machine migration. Install with:
#   brew bundle install --file ~/.config/Brewfile
#
# Toolchain note: Python is managed by `uv` (interpreters + tools), Node by `fnm`.
# nvim linters/LSPs are installed via Mason (see nvim/init.lua ensure_installed),
# NOT as global npm packages.

tap "espanso/espanso"
tap "wezterm/wezterm", "https://github.com/wezterm/homebrew-wezterm.git"

# Record and share terminal sessions
brew "asciinema", link: false
# Azure Storage data transfer utility
brew "azcopy"
# Microsoft Azure CLI 2.0
brew "azure-cli"
# Clone of cat(1) with syntax highlighting and Git integration
brew "bat"
# Fast Node version manager (Rust) — see nvim/Mason note above
brew "fnm"
# Command-line fuzzy finder written in Go
brew "fzf"
# GitHub command-line tool
brew "gh"
# Syntax-highlighting pager for git and diff output
brew "git-delta"
# Quickly rewrite git repository history
brew "git-filter-repo"
# Smarter Dockerfile linter to validate best practices
brew "hadolint"
# Lightweight and flexible command-line JSON processor
brew "jq"
# Handy way to save and run project-specific commands
brew "just"
# Clone of ls with colorful output, file type icons, and more
brew "lsd"
# Language Server Protocol for Markdown
brew "marksman"
# Ambitious Vim-fork focused on extensibility and agility
brew "neovim"
# Development kit for the Java programming language
brew "openjdk@17"
# PAM module for reattaching to the user's GUI (Aqua) session
brew "pam-reattach"
# Swiss-army knife of markup format conversion
brew "pandoc"
# Software environment for statistical computing
brew "r"
# Powerful, clean, object-oriented scripting language
brew "ruby", link: false
# Rust toolchain installer
brew "rustup"
# Static analysis and lint tool, for (ba)sh scripts
brew "shellcheck"
# Formatting tool for reformatting Swift code
brew "swiftformat"
# Tool to enforce Swift style and conventions
brew "swiftlint"
# Tool Command Language
brew "tcl-tk"
# Code-search similar to ack
brew "the_silver_searcher"
# Granddaddy of HTML tools, with support for modern standards
brew "tidy-html5"
# Terminal multiplexer
brew "tmux"
# Display directories as trees (with optional color/HTML output)
brew "tree"
# Extremely fast Python package/interpreter manager (Python toolchain)
brew "uv"
# Syntax-aware linter for prose
brew "vale"
# Internet file retriever
brew "wget"
# Generate your Xcode project from a spec file and your folder structure
brew "xcodegen"
# Linter for YAML files
brew "yamllint"

# Family of tools to build, test and package software
cask "docker-desktop"
# Cross-platform Text Expander written in Rust
cask "espanso"
# Utility for customizing which browser to start
cask "finicky"
cask "font-atkynson-mono-nerd-font"
cask "font-caskaydia-cove-nerd-font"
cask "font-fira-code-nerd-font"
cask "font-hack-nerd-font"
cask "font-monaspace"
# 2D and 3D game engine
cask "godot"
# Convert caps lock / a modifier to a hyper key
cask "hyperkey"
# Tool to prevent the system from going into sleep mode
cask "keepingyouawake"
# Open-source cross-platform alternative to AirDrop
cask "localsend"
# Scientific and technical publishing system built on Pandoc
cask "quarto"
# Window manager
cask "rectangle"
# Subscription app launcher (Setapp apps install from within it — see docs/machine-migration.md)
cask "setapp"
# Menu Bar manager
cask "thaw"
# Multimedia player
cask "vlc"
# GPU-accelerated cross-platform terminal emulator and multiplexer
cask "wezterm"
# Switch apps, windows, or tabs (alt-tab behavior)
cask "witch"

# Rust CLI tools (require cargo — installed after `rustup` sets a default toolchain;
# re-run `brew bundle install` once rustup is set up if these fail on first pass)
cargo "cargo-nextest"
cargo "cargo-swift"
cargo "cargo-xcode"
