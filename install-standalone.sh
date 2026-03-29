#!/usr/bin/env bash

set -euo pipefail

# --- Configuration ---
BASE_CONFIG="base"
CONFIG_SUFFIX=".yaml"
META_DIR="meta"
CONFIG_DIR="configs"
DOTBOT_DIR="dotbot"
DOTBOT_BIN="bin/dotbot"

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${BASE_DIR}"

# Parse arguments
UPDATE_DOTBOT=false
CONFIGS=()

for arg in "$@"; do
    case "$arg" in
        --update-dotbot)
            UPDATE_DOTBOT=true
            ;;
        *)
            CONFIGS+=("$arg")
            ;;
    esac
done

if [ ${#CONFIGS[@]} -lt 1 ]; then
    echo "Usage: $0 [--update-dotbot] <config1> [config2] ..."
    exit 1
fi

echo "🚀 Initializing submodules..."
# Only update if .git/modules exists (submodule not initialized) or if explicitly needed
if [ "$UPDATE_DOTBOT" = true ]; then
    echo "🔄 Updating dotbot from remote..."
    git submodule update --init --recursive --remote
elif [ ! -d "${BASE_DIR}/.git/modules" ]; then
    git submodule update --init --recursive
else
    # Skip fetch/update for faster re-runs, submodules already initialized
    echo "✨ Submodules already initialized, skipping fetch..."
fi

# Create a temporary file for the combined config
COMBINED_CONFIG=$(mktemp)
trap 'rm -f "$COMBINED_CONFIG"' EXIT

# 1. Start with Base Config
cat "${BASE_DIR}/${META_DIR}/${BASE_CONFIG}${CONFIG_SUFFIX}" > "$COMBINED_CONFIG"

# 2. Append each config fragment
VALID_CONFIG_COUNT=0
SUDO_REQUIRED=false

for config in "${CONFIGS[@]}"; do
    # Check for sudo suffix
    suffix="-sudo"
    clean_name="${config%"$suffix"}"
    
    config_path="${BASE_DIR}/${META_DIR}/${CONFIG_DIR}/${clean_name}${CONFIG_SUFFIX}"
    
    if [ ! -f "${config_path}" ]; then
        echo "⚠️  Warning: Configuration file '${clean_name}' not found. Skipping."
        continue
    fi

    if [[ $config == *"sudo"* ]]; then
        SUDO_REQUIRED=true
    fi

    echo -e "\n# --- Fragment: $clean_name ---" >> "$COMBINED_CONFIG"
    sed '1{/^--- *$/d;}' "${config_path}" >> "$COMBINED_CONFIG"
    VALID_CONFIG_COUNT=$((VALID_CONFIG_COUNT + 1))
done

if [ "$VALID_CONFIG_COUNT" -eq 0 ]; then
    echo "❌ Error: No valid configuration fragments found. Aborting."
    exit 1
fi

echo "✨ Deploying ${VALID_CONFIG_COUNT} standalone fragments via Dotbot..."

# 3. Run Dotbot ONCE
CMD=("${BASE_DIR}/${DOTBOT_DIR}/${DOTBOT_BIN}" -d "${BASE_DIR}" -c "$COMBINED_CONFIG")

if [ "$SUDO_REQUIRED" = true ]; then
    sudo "${CMD[@]}"
else
    "${CMD[@]}"
fi

echo -e "\n✅ Finished standalone installation!"
