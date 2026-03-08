#!/usr/bin/env bash

set -euo pipefail

# --- Colors ---
BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}🔧 Starting SketchyBar Setup...${NC}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 1. Homebrew Dependencies
echo "📦 Checking system dependencies..."
DEPS=(
    "lua"
    "luarocks"
    "switchaudio-osx"
    "media-control"
    "jq"
    "sketchybar"
)

for dep in "${DEPS[@]}"; do
    if ! brew list "$dep" &>/dev/null; then
        echo "Installing $dep..."
        brew install "$dep"
    else
        echo "✅ $dep is already installed"
    fi
done

# 2. SketchyBar App Font
echo -e "\n🎨 Installing SketchyBar App Font..."
FONT_DIR="$HOME/code/clones/sketchybar-app-font"
if [ ! -d "$FONT_DIR" ]; then
    mkdir -p "$(dirname "$FONT_DIR")"
    git clone https://github.com/kvndrsslr/sketchybar-app-font "$FONT_DIR"
else
    cd "$FONT_DIR" && git pull
fi

cd "$FONT_DIR"
if command -v bun &>/dev/null; then
    bun install && bun run build
elif command -v pnpm &>/dev/null; then
    pnpm install && pnpm run build
else
    echo -e "${RED}Error: Neither bun nor pnpm found for font building.${NC}"
    exit 1
fi

# Link fonts and icon maps
cp -f "./dist/sketchybar-app-font.ttf" "$HOME/Library/Fonts/"
cp -f "./dist/icon_map.lua" "$SCRIPT_DIR/helpers/app_icons.lua"
echo "✅ Font and app_icons.lua updated."

# 3. SbarLua
echo -e "\n📦 Checking SbarLua..."
if [ ! -d "$HOME/.local/share/sketchybar_lua" ]; then
    git clone https://github.com/FelixKratz/SbarLua.git /tmp/SbarLua
    cd /tmp/SbarLua && make install
    rm -rf /tmp/SbarLua
    echo "✅ SbarLua installed."
else
    echo "✅ SbarLua already exists."
fi

# 4. Lua Rocks (JSON)
if ! luarocks list --porcelain lua-cjson | grep -q "lua-cjson"; then
    echo "Installing lua-cjson..."
    luarocks install lua-cjson --local
fi

# 5. Compile C Helpers
echo -e "\n🛠️ Compiling C helpers..."
cd "$SCRIPT_DIR/helpers"
make clean 2>/dev/null || true
make

echo -e "\n${GREEN}✨ SketchyBar setup complete!${NC}"
echo "💡 Run 'brew services restart sketchybar' to apply changes."
