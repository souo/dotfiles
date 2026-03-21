#!/bin/bash
# ==============================================================================
# Script Name: setup_ssh.sh
# Description: Automates SSH key generation, initializes ~/.ssh/config,
#              starts ssh-agent, adds the key, and provides quick links.
# ==============================================================================

# Exit immediately if a command exits with a non-zero status
set -e

# Define color codes for output formatting
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color (Reset)

# Prompt user for device identifier/email
echo -e "${CYAN}Enter your email or device identifier (e.g., user@example.com - Mac):${NC} \c"
read -r IDENTIFIER

SSH_DIR="$HOME/.ssh"
KEY_PATH="$SSH_DIR/id_ed25519"
CONFIG_PATH="$SSH_DIR/config"

echo -e "\n${CYAN}------------------------------------------------${NC}"
echo -e "${CYAN}🚀 Starting SSH Setup for: $IDENTIFIER${NC}"
echo -e "${CYAN}------------------------------------------------${NC}"

# Step 1: Create .ssh directory if it doesn't exist and set permissions
if [ ! -d "$SSH_DIR" ]; then
    echo -e "${GREEN}Creating .ssh directory...${NC}"
    mkdir -p "$SSH_DIR"
    chmod 700 "$SSH_DIR"
else
    echo -e "${YELLOW}Directory $SSH_DIR already exists.${NC}"
fi

# Step 2: Generate SSH key if it doesn't already exist
if [ -f "$KEY_PATH" ]; then
    echo -e "${YELLOW}WARNING: SSH key already exists at $KEY_PATH.${NC}"
    echo -e "${YELLOW}Skipping key generation to prevent overwriting your existing private key.${NC}"
else
    echo -e "${GREEN}Generating new ed25519 SSH key...${NC}"
    ssh-keygen -t ed25519 -C "$IDENTIFIER" -f "$KEY_PATH"
fi

# Step 3: Initialize config file if it doesn't exist
if [ ! -f "$CONFIG_PATH" ]; then
    echo -e "${GREEN}Initializing ~/.ssh/config file...${NC}"
    cat <<EOF > "$CONFIG_PATH"
# --- Default Settings for all hosts ---
Host *
    ServerAliveInterval 60
    AddKeysToAgent yes
    # UseKeychain yes # NOTE: Uncomment this line if you are on macOS

# --- GitHub Configuration ---
Host github.com
    HostName github.com
    User git
    IdentityFile $KEY_PATH
EOF
    echo -e "${GREEN}Basic config file created.${NC}"
else
    echo -e "${YELLOW}File $CONFIG_PATH already exists. Skipping initialization.${NC}"
fi

# Step 4: Ensure strict permissions (SSH requires this)
echo -e "${GREEN}Setting strict permissions for SSH files...${NC}"
chmod 700 "$SSH_DIR"
chmod 600 "$KEY_PATH"
chmod 644 "$KEY_PATH.pub"
if [ -f "$CONFIG_PATH" ]; then
    chmod 600 "$CONFIG_PATH"
fi

# Step 5: Start ssh-agent and add the key
echo -e "${GREEN}Starting ssh-agent and adding the key...${NC}"
# Start the ssh-agent in the background
eval "$(ssh-agent -s)"
# Add the newly generated SSH private key to the ssh-agent
ssh-add "$KEY_PATH"

# Step 6: Display Public Key and Links for the user
echo ""
echo -e "${GREEN}=================================================================${NC}"
echo -e "${GREEN}✅ Setup Complete! Here is your PUBLIC KEY:${NC}"
echo -e "${CYAN}-----------------------------------------------------------------${NC}"
cat "$KEY_PATH.pub"
echo -e "${CYAN}-----------------------------------------------------------------${NC}"
echo -e "${YELLOW}Next Step: Copy the text above and click the links below to add it:${NC}"
echo ""
echo -e "👉 ${CYAN}GitHub:${NC} https://github.com/settings/keys"
echo -e "👉 ${CYAN}GitLab:${NC} https://gitlab.com/-/user_settings/ssh_keys"
echo -e "${GREEN}=================================================================${NC}"
