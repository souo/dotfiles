#!/usr/bin/env bash

# --- Raycast Script Command Metadata ---
# @raycast.schemaVersion 1
# @raycast.title Dotfiles: Rebuild (Dry-run)
# @raycast.mode fullOutput
# @raycast.packageName Dotfiles
# @raycast.icon 🛠️

# @raycast.description Run a dry-run of the macOS profile deployment
# @raycast.author 2z

set -e

DOTFILES_ROOT="$HOME/.dotfiles"

echo "🚀 Running Dotfiles Dry-run (mac profile)..."
cd "$DOTFILES_ROOT"
just dry-run mac

echo -e "\n✅ Check complete!"
