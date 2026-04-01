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
echo "🚀 Initializing submodules..."
git submodule update --init --recursive

# Read configs from profile (ignore empty lines and comments)
mapfile -t CONFIGS < <(grep -vE '^\s*(#|$)' "${PROFILE_FILE}")

# Add extra configs from command line
for extra in ${EXTRA_CONFIGS}; do
    CONFIGS+=("${extra}")
done

echo "📦 Preparing unified configuration for profile: ${PROFILE_NAME}..."

# Create a temporary file for the combined config
COMBINED_CONFIG=$(mktemp)
trap 'rm -f "$COMBINED_CONFIG"' EXIT

# 1. Start with Base Config
cat "${BASE_DIR}/${META_DIR}/${BASE_CONFIG}${CONFIG_SUFFIX}" > "$COMBINED_CONFIG"

# 2. Append each config fragment
VALID_CONFIG_COUNT=0
for config in "${CONFIGS[@]}"; do
    config_path="${BASE_DIR}/${META_DIR}/${CONFIG_DIR}/${config}${CONFIG_SUFFIX}"

    if [ ! -f "${config_path}" ]; then
        echo "⚠️  Warning: Configuration file '${config}' not found. Skipping."
        continue
    fi

    echo -e "\n# --- Fragment: $config ---" >> "$COMBINED_CONFIG"
    # Append content, stripping potential leading YAML document separators
    sed '1{/^--- *$/d;}' "${config_path}" >> "$COMBINED_CONFIG"
    VALID_CONFIG_COUNT=$((VALID_CONFIG_COUNT + 1))
done

if [ "$VALID_CONFIG_COUNT" -eq 0 ]; then
    echo "❌ Error: No valid configuration fragments found. Aborting."
    exit 1
fi

echo "✨ Deploying ${VALID_CONFIG_COUNT} fragments via Dotbot..."

# 3. Run Dotbot ONCE
if [ -n "$DRY_RUN" ]; then
    "${BASE_DIR}/${DOTBOT_DIR}/${DOTBOT_BIN}" -d "${BASE_DIR}" -c "$COMBINED_CONFIG" --dry-run
else
    "${BASE_DIR}/${DOTBOT_DIR}/${DOTBOT_BIN}" -d "${BASE_DIR}" -c "$COMBINED_CONFIG"
fi

# --- 🔗 Dead Link Check ---
echo -e "\n🔍 Checking for orphaned dotfile links in ~ ..."
# Portable way to find dead links pointing to this repo
while read -r link; do
    if [ ! -e "$link" ]; then
        echo "⚠️  Found dead link: $link (pointing to a missing file in your dotfiles)"
    fi
done < <(find ~ -maxdepth 2 -type l -lname "*$BASE_DIR*" 2>/dev/null || true)

echo -e "\n✅ Finished deploying ${PROFILE_NAME}!"
