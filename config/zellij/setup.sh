#!/usr/bin/env bash

set -e

# Check if .aliases exists and add alias there too
if [ -f "$HOME/.aliases" ]; then
    if ! grep -q "alias vibe=" "$HOME/.aliases" 2>/dev/null; then
        echo "" >> "$HOME/.aliases"
        echo "alias vibe='zellij --layout vibe'" >> "$HOME/.aliases"
    fi
fi
