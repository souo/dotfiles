#!/usr/bin/env bash

set -euo pipefail

# --- Configuration ---
BASE_CONFIG="base"
CONFIG_SUFFIX=".yaml"
META_DIR="meta"
CONFIG_DIR="configs"
PROFILES_DIR="profiles"
DOTBOT_DIR="dotbot"
DOTBOT_BIN="bin/dotbot"

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${BASE_DIR}"

# --- Helper Functions ---
show_help() {
    echo "Usage: $0 [options] <profile_name> [extra_configs...]"
    echo ""
    echo "Options:"
    echo "  -d, --dry-run    Run dotbot in dry-run mode"
    echo "  -h, --help       Show this help message"
}

# --- Argument Parsing ---
DRY_RUN=""
while [[ $# -gt 0 ]]; do
    case $1 in
        -d|--dry-run)
            DRY_RUN="--dry-run"
            shift
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        -*)
            echo "Unknown option: $1"
            show_help
            exit 1
            ;;
        *)
            break
            ;;
    esac
done

if [ $# -lt 1 ]; then
    echo "Error: Profile name is required."
    show_help
    exit 1
fi

PROFILE_NAME="$1"
shift
EXTRA_CONFIGS="$*"

PROFILE_FILE="${BASE_DIR}/${META_DIR}/${PROFILES_DIR}/${PROFILE_NAME}"

if [ ! -f "${PROFILE_FILE}" ]; then
    echo "Error: Profile '${PROFILE_NAME}' not found at ${PROFILE_FILE}"
    exit 1
fi

# --- Execution ---
echo "Initializing submodules..."
git submodule update --init --recursive 

# Read configs from profile (ignore empty lines and comments)
mapfile -t CONFIGS < <(grep -vE '^\s*(#|$)' "${PROFILE_FILE}")

# Add extra configs from command line
for extra in ${EXTRA_CONFIGS}; do
    CONFIGS+=("${extra}")
done

echo "Deploying profile: ${PROFILE_NAME} ${DRY_RUN:+($DRY_RUN)}"

for config in "${CONFIGS[@]}"; do
    config_path="${BASE_DIR}/${META_DIR}/${CONFIG_DIR}/${config}${CONFIG_SUFFIX}"
    
    if [ ! -f "${config_path}" ]; then
        echo "Warning: Configuration file '${config}' not found at ${config_path}. Skipping."
        continue
    fi

    echo -e "\n--- Configure $config ---"
    configFile=$(mktemp)
    trap 'rm -f "$configFile"' EXIT
    
    # 1. Start with Base Config (removing potential leading ---)
    sed '1{/^--- *$/d;}' "${BASE_DIR}/${META_DIR}/${BASE_CONFIG}${CONFIG_SUFFIX}" > "$configFile"
    
    # 2. Add newline
    echo "" >> "$configFile"
    
    # 3. Append current Config
    sed '1{/^--- *$/d;}' "${config_path}" >> "$configFile"
    
    # 4. Run Dotbot
    if [ -n "$DRY_RUN" ]; then
        "${BASE_DIR}/${DOTBOT_DIR}/${DOTBOT_BIN}" -d "${BASE_DIR}" -c "$configFile" --dry-run
    else
        "${BASE_DIR}/${DOTBOT_DIR}/${DOTBOT_BIN}" -d "${BASE_DIR}" -c "$configFile"
    fi
    
    rm -f "$configFile"
    trap - EXIT
done

# --- 🔗 Dead Link Check ---
echo -e "\n🔍 Checking for orphaned dotfile links in ~ ..."
find ~ -maxdepth 2 -xtype l -lname "*$BASE_DIR*" 2>/dev/null | while read -r link; do
    echo "⚠️  Found dead link: $link (pointing to a missing file in your dotfiles)"
done

echo -e "\n✅ Finished deploying ${PROFILE_NAME}!"
