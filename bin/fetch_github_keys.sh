#!/bin/bash
# ==============================================================================
# Script Name: fetch_github_keys.sh
# Description: Fetches public keys from a GitHub user and securely appends 
#              them to the ~/.ssh/authorized_keys file.
# ==============================================================================

set -e

# Color definitions
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Step 1: Prompt for GitHub username
echo -e "${CYAN}Enter your GitHub username to fetch public keys:${NC} \c"
read GITHUB_USER

if [ -z "$GITHUB_USER" ]; then
    echo -e "${RED}Error: GitHub username cannot be empty.${NC}"
    exit 1
fi

echo -e "\n${CYAN}Fetching keys for GitHub user: $GITHUB_USER...${NC}"
KEYS_URL="https://github.com/${GITHUB_USER}.keys"

# Step 2: Download the keys silently using curl
# We temporarily disable 'set -e' to handle potential curl errors gracefully
set +e
FETCHED_KEYS=$(curl -s -f "$KEYS_URL")
CURL_EXIT_CODE=$?
set -e

# Step 3: Validate the fetched data
if [ $CURL_EXIT_CODE -ne 0 ] || [ -z "$FETCHED_KEYS" ]; then
    echo -e "${RED}Error: Failed to fetch keys. Please check if the username '$GITHUB_USER' is correct and has public keys uploaded.${NC}"
    exit 1
fi

SSH_DIR="$HOME/.ssh"
AUTH_KEYS_FILE="$SSH_DIR/authorized_keys"

# Step 4: Ensure .ssh directory exists with correct permissions
if [ ! -d "$SSH_DIR" ]; then
    echo -e "${YELLOW}Creating $SSH_DIR directory...${NC}"
    mkdir -p "$SSH_DIR"
    chmod 700 "$SSH_DIR"
fi

# Step 5: Append the fetched keys to authorized_keys
echo -e "${GREEN}Successfully retrieved keys. Appending to $AUTH_KEYS_FILE...${NC}"
# Use echo to append the multi-line string to the file safely
echo "$FETCHED_KEYS" >> "$AUTH_KEYS_FILE"

# Step 6: Ensure strict permissions for the authorized_keys file
chmod 600 "$AUTH_KEYS_FILE"

echo -e "${GREEN}=================================================================${NC}"
echo -e "${GREEN}✅ Success! The following keys were added to authorized_keys:${NC}"
echo -e "${CYAN}-----------------------------------------------------------------${NC}"
echo "$FETCHED_KEYS"
echo -e "${CYAN}-----------------------------------------------------------------${NC}"
echo -e "${GREEN}Your devices can now SSH into this machine using these keys.${NC}"
echo -e "${GREEN}=================================================================${NC}"