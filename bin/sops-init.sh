#!/usr/bin/env bash
set -euo pipefail

# Check for dependencies
if ! command -v age-keygen &> /dev/null || ! command -v sops &> /dev/null; then
    echo "❌ Error: 'age' and 'sops' are required."
    echo "Please install them first (e.g., via Homebrew or apt)."
    exit 1
fi

AGE_DIR="$HOME/.config/sops/age"
KEY_FILE="$AGE_DIR/keys.txt"
SOPS_CONFIG="$HOME/.dotfiles/.sops.yaml"
SECRETS_FILE="$HOME/.dotfiles/config/zsh/common/.env.secret.sops"

echo "🔐 Initializing SOPS + Age for Secret Management..."

# Generate local Age key if it doesn't exist
if [[ ! -f "$KEY_FILE" ]]; then
    echo "Generating new Age identity at $KEY_FILE..."
    mkdir -p "$AGE_DIR"
    age-keygen -o "$KEY_FILE"
else
    echo "✅ Age key already exists at $KEY_FILE"
fi

# Extract the public key
PUB_KEY=$(grep "public key:" "$KEY_FILE" | awk '{print $4}')
echo "Your Public Key: $PUB_KEY"

# Create/Update .sops.yaml in dotfiles root
echo "Configuring $SOPS_CONFIG..."
cat <<EOF > "$SOPS_CONFIG"
creation_rules:
  - path_regex: .*\.sops$
    key_groups:
      - age:
          - "$PUB_KEY"
EOF
echo "✅ .sops.yaml configured for public key."

# Initialize dummy secrets file if not present
if [[ ! -f "$SECRETS_FILE" ]]; then
    echo "Creating initial encrypted secrets template at $SECRETS_FILE..."
    # Create a temporary unencrypted file
    TMP_SEC=$(mktemp)
    mv "$TMP_SEC" "${TMP_SEC}.sops"
    TMP_SEC="${TMP_SEC}.sops"

    echo "# Place your secrets below, they will be encrypted by SOPS" > "$TMP_SEC"
    echo "HELLO_SECRET=world" >> "$TMP_SEC"

    # Encrypt it
    SOPS_AGE_KEY_FILE="$KEY_FILE" sops --encrypt --input-type dotenv --output-type dotenv "$TMP_SEC" > "$SECRETS_FILE"
    rm "$TMP_SEC"
    echo "✅ Created encrypted template $SECRETS_FILE."
else
    echo "✅ Encrypted secrets file already exists."
fi

echo ""
echo "🎉 SOPS is fully initialized!"
echo "⚠️  IMPORTANT: Please backup your private key to Bitwarden!"
echo "   Create a Secure Note named 'dotfiles-age-key' and paste the content of:"
echo "   $KEY_FILE"
echo "   This allows you to restore it on other machines using 'just sops-restore'."
echo ""
echo "👉 Run 'just secret-edit' to add your API keys securely."
echo "👉 Run 'just secret-sync' to dynamically decrypt them to ~/.zsh_secret so they are recognized by Zsh."
echo "👉 Run 'just claude-secret-edit' to edit Claude Code settings."
echo "👉 Run 'just claude-secret-sync' to decrypt Claude settings to ~/.claude/settings.json."
