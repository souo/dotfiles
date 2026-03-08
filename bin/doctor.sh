#!/usr/bin/env bash

# --- Raycast Script Command Metadata ---
# @raycast.schemaVersion 1
# @raycast.title Dotfiles: Doctor (Health Check)
# @raycast.mode fullOutput
# @raycast.packageName Dotfiles
# @raycast.icon 🩺

# @raycast.description Run a comprehensive health check on your dotfiles environment
# @raycast.author 2z

set -u

# --- 🎨 Colors ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# --- 📂 Paths ---
DOTFILES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

print_section() {
    echo -e "\n${BLUE}=== $1 ===${NC}"
}

check_tool() {
    if command -v "$1" >/dev/null 2>&1; then
        echo -e "${GREEN}[OK]${NC} $1 is installed"
        return 0
    else
        echo -e "${RED}[MISSING]${NC} $1 is not found"
        return 1
    fi
}

check_file() {
    if [[ -f "$1" ]]; then
        echo -e "${GREEN}[OK]${NC} $2 exists ($1)"
    else
        echo -e "${YELLOW}[WARNING]${NC} $2 is missing ($1)"
    fi
}

# --- 🚀 Start Doctor ---
echo -e "${BLUE}🩺 Dotfiles Doctor - System Health Check${NC}"
echo -e "Root: $DOTFILES_ROOT"

# 1. Core Toolchain
print_section "Core Toolchain"
TOOLS=("bun" "python3" "zsh" "nvim" "wezterm" "atuin" "zoxide" "fzf" "starship" "oh-my-posh" "aerospace")
for tool in "${TOOLS[@]}"; do
    check_tool "$tool"
done

# 2. Security & Secrets
print_section "Security & Secrets"
check_file "$HOME/.zsh_secret" "Private environment file"
check_file "$HOME/.localrc" "Machine-specific shell config"
check_file "$HOME/.config/karabiner/karabiner.json" "Karabiner configuration"

# 3. Symbolic Links
print_section "Symbolic Links"
echo "Checking for broken links pointing to $DOTFILES_ROOT..."
BROKEN_LINKS=$(find ~ -maxdepth 2 -xtype l -lname "*$DOTFILES_ROOT*" 2>/dev/null)
if [[ -z "$BROKEN_LINKS" ]]; then
    echo -e "${GREEN}[OK]${NC} No broken symbolic links found."
else
    echo -e "${RED}[ERROR]${NC} Found broken links:"
    echo "$BROKEN_LINKS"
fi

# 4. Permissions
print_section "Script Permissions"
UNEXECUTABLE=$(find "$DOTFILES_ROOT/bin" "$DOTFILES_ROOT/setups" -name "*.sh" ! -executable)
if [[ -z "$UNEXECUTABLE" ]]; then
    echo -e "${GREEN}[OK]${NC} All shell scripts are executable."
else
    echo -e "${RED}[ERROR]${NC} Following scripts missing +x bit:"
    echo "$UNEXECUTABLE"
fi

# 5. Git Status
print_section "Git Repository Status"
cd "$DOTFILES_ROOT"
if [[ -n $(git status --porcelain) ]]; then
    echo -e "${YELLOW}[DIRTY]${NC} You have uncommitted changes in your dotfiles repository."
else
    echo -e "${GREEN}[CLEAN]${NC} Repository is clean."
fi

UPSTREAM=$(git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null || echo "")
if [[ -n "$UPSTREAM" ]]; then
    git fetch origin --quiet
    LOCAL=$(git rev-parse HEAD)
    REMOTE=$(git rev-parse "$UPSTREAM")
    if [ "$LOCAL" != "$REMOTE" ]; then
        echo -e "${YELLOW}[OUTDATED]${NC} Local branch is not in sync with $UPSTREAM."
    else
        echo -e "${GREEN}[UP-TO-DATE]${NC} Local branch is in sync with upstream."
    fi
fi

echo -e "\n${BLUE}✨ Doctor check finished!${NC}"
