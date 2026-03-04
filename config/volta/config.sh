#!/usr/bin/env bash

set -e

# Check if .aliases exists and add alias there too
if [ -f "$HOME/.env" ]; then
    if ! grep -q "export VOLTA_HOME=" "$HOME/.env" 2>/dev/null; then
        echo "" >> "$HOME/.env"
        echo "export VOLTA_HOME=$HOME/.volta" >> "$HOME/.env"
        echo 'export PATH="$VOLTA_HOME/bin:$PATH"' >> "$HOME/.env"
    fi
fi