#!/usr/bin/env bash

set -euo pipefail

# --- Colors ---
BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FONT_DIR="$HOME/code/clones/sketchybar-app-font"
ASSETS_DIR="$SCRIPT_DIR/assets"
LOCAL_SVGS="$ASSETS_DIR/svgs"
LOCAL_MAPS="$ASSETS_DIR/mappings"

echo -e "${BLUE}🎨 Patching & Building SketchyBar App Font...${NC}"

# 1. Sync Source
if [ ! -d "$FONT_DIR" ]; then
    mkdir -p "$(dirname "$FONT_DIR")"
    git clone https://github.com/kvndrsslr/sketchybar-app-font "$FONT_DIR"
else
    cd "$FONT_DIR" && git pull
fi

# 2. Inject custom SVGs and mappings
if [ -d "$LOCAL_SVGS" ] && [ "$(ls -A "$LOCAL_SVGS" 2>/dev/null)" ]; then
    echo "📥 Injecting custom SVGs from $LOCAL_SVGS..."
    cp -f "$LOCAL_SVGS"/*.svg "$FONT_DIR/svgs/"
fi

if [ -d "$LOCAL_MAPS" ] && [ "$(ls -A "$LOCAL_MAPS" 2>/dev/null)" ]; then
    echo "📥 Injecting custom mappings from $LOCAL_MAPS..."
    find "$LOCAL_MAPS" -type f -maxdepth 1 -exec cp -f {} "$FONT_DIR/mappings/" \;
fi

# 3. Build
cd "$FONT_DIR"
echo "🛠️ Running build script..."
if command -v pnpm &>/dev/null; then
    pnpm install && pnpm run build
else
    echo -e "${RED}Error: Neither bun nor pnpm found for font building.${NC}"
    exit 1
fi

# 4. Deploy results
echo "🚀 Deploying font and icon map..."
cp -f "./dist/sketchybar-app-font.ttf" "$HOME/Library/Fonts/"
cp -f "./dist/icon_map.lua" "$SCRIPT_DIR/helpers/icon_map.lua"

echo -e "${GREEN}✅ Font patched and deployed successfully!${NC}"
