#!/usr/bin/env bash
set -euo pipefail

# Check for dependencies
if ! command -v bw &> /dev/null; then
    echo "❌ Error: Bitwarden CLI ('bw') is required but not found in PATH."
    echo "Please install it first: brew install bitwarden-cli"
    exit 1
fi

if ! command -v jq &> /dev/null; then
    echo "❌ Error: 'jq' is required but not found in PATH."
    echo "Please install it first: brew install jq"
    exit 1
fi

# Check Bitwarden login/unlock status
BW_STATUS=$(bw status | jq -r '.status')
if [[ "$BW_STATUS" == "unauthenticated" ]]; then
    echo "❌ Error: Bitwarden CLI is not logged in."
    echo "Run 'bw login' first."
    exit 1
fi

if [[ "$BW_STATUS" == "locked" ]]; then
    echo "🔒 Bitwarden vault is locked."
    echo "Please unlock it and export the session key (e.g., 'export BW_SESSION=\$(bw unlock --raw)')."
    exit 1
fi

# Configuration
AGE_DIR="$HOME/.config/sops/age"
KEY_FILE="$AGE_DIR/keys.txt"
BACKUP_FILE="${KEY_FILE}.bak.$(date +%Y%m%d%H%M%S)"
NOTE_NAME="dotfiles-age-key"

echo "🔐 Restoring SOPS Age key from Bitwarden..."

# Fetch the note
# Note: This assumes the note content is exactly the private key text.
# We use || true to prevent set -e from exiting so we can show a better error message.
AGE_KEY=$(bw get notes "$NOTE_NAME" 2>/dev/null || true)

if [[ -z "$AGE_KEY" ]]; then
    echo "❌ Error: Could not find a Secure Note named '$NOTE_NAME' in Bitwarden."
    echo "Please create a Secure Note in Bitwarden with exactly that name and the content of your keys.txt."
    exit 1
fi

# Sanity check: Does it look like an age secret key?
if [[ ! "$AGE_KEY" =~ "AGE-SECRET-KEY-" ]]; then
    echo "❌ Error: The content of '$NOTE_NAME' does not look like a valid Age secret key."
    echo "It should start with 'AGE-SECRET-KEY-'."
    exit 1
fi

# Prepare target directory
mkdir -p "$AGE_DIR"

# Backup existing key if it exists
if [[ -f "$KEY_FILE" ]]; then
    echo "Warning: $KEY_FILE already exists. Backing up to $BACKUP_FILE."
    mv "$KEY_FILE" "$BACKUP_FILE"
fi

# Write key file
echo "$AGE_KEY" > "$KEY_FILE"
chmod 600 "$KEY_FILE"

echo "✅ Successfully restored SOPS Age key to $KEY_FILE"
echo "👉 You can now run 'just secret-sync' to decrypt your secrets."
