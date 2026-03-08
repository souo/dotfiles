#!/usr/bin/env bash

set -euo pipefail

echo "🚀 Starting post-create setup..."

# 1. Initialize submodules
git submodule update --init --recursive

# 2. Deploy the Ubuntu profile
echo "📦 Deploying dotfiles (Ubuntu profile)..."
chmod +x ./install-profile.sh
./install-profile.sh ubuntu

# 3. Bun install (for changesets/lefthook etc)
echo "🥟 Installing Bun dependencies..."
bun install

echo "✅ Development container setup complete!"
echo "💡 Use 'zsh' to start your optimized shell."
