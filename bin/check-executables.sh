#!/usr/bin/env bash

# --- Raycast Script Command Metadata ---
# @raycast.schemaVersion 1
# @raycast.title Dotfiles: Check Executables
# @raycast.mode compact
# @raycast.packageName Dotfiles
# @raycast.icon 🛡️

set -e

echo "🔍 Checking shell scripts for executable bits..."

FAILED=0
# Find all staged or modified .sh files in bin, setups, and root
# We use git ls-files to check what's in the repo
FILES=$(git ls-files | grep '\.sh$' || true)

for file in $FILES; do
    if [[ ! -x "$file" ]]; then
        echo "❌ Error: $file is not executable. Fix with: chmod +x $file"
        FAILED=1
    fi
done

if [ $FAILED -eq 1 ]; then
    echo "🚨 Some scripts are missing executable permissions!"
    exit 1
else
    echo "✅ All scripts are executable."
    exit 0
fi
