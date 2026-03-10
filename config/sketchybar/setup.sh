#!/usr/bin/env bash

set -euo pipefail

# --- Colors ---
BLUE='\033[0;34m'
GREEN='\033[0;32m'
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
echo -e "\n🎨 Installing & Customizing SketchyBar App Font..."
chmod +x "$SCRIPT_DIR/build_font.sh"
"$SCRIPT_DIR/build_font.sh"

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

# Ask for service restart
read -p "🚀 Would you like to restart SketchyBar now? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🔄 Restarting SketchyBar..."
    brew services restart sketchybar
else
    echo "💡 You can restart it later with: brew services restart sketchybar"
fi
