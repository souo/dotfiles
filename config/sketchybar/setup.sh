#!/bin/bash

# SketchyBar Dependencies Installation Script
# Run this once on a new machine after copying your sketchybar config

set -e

echo "🔧 Installing SketchyBar dependencies..."
echo ""

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "❌ Homebrew not found. Please install it first:"
    echo "   /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
    exit 1
fi

# Install Lua
if ! brew list lua &> /dev/null; then
    echo "📦 Installing lua..."
    brew install lua
else
    echo "✅ lua already installed"
fi

# Install luarocks
if ! command -v luarocks &> /dev/null; then
    echo "📦 Installing luarocks..."
    brew install luarocks
else
    echo "✅ luarocks already installed"
fi


# Install switchaudio-osx (for volume control)
if ! command -v SwitchAudioSource &> /dev/null; then
    echo "📦 Installing switchaudio-osx..."
    brew install switchaudio-osx
else
    echo "✅ switchaudio-osx already installed"
fi

# Install media-control (for media controls)
if ! command -v media-control &> /dev/null; then
    echo "📦 Installing media-control..."
    brew install media-control
else
    echo "✅ media-control already installed"
fi


# Install SketchyBar
echo "📦 Checking SketchyBar..."
if ! command -v sketchybar &> /dev/null; then
    brew tap FelixKratz/formulae
    brew install sketchybar
    echo "✅ SketchyBar installed"
else
    echo "✅ SketchyBar already installed"
fi

# SketchyBar App Font
echo "📦 Installing sketchybar-app-font..."

CLONE_DIR="$HOME/code/clones"
REPO_NAME="sketchybar-app-font"
TARGET_PATH="$CLONE_DIR/$REPO_NAME"
REPO_URL="https://github.com/kvndrsslr/sketchybar-app-font"

mkdir -p "$CLONE_DIR"

if [ -d "$TARGET_PATH" ]; then
    echo "📂 目录已存在，正在尝试更新..."
    cd "$TARGET_PATH" || exit
    git pull
else
    echo "🚀 目录不存在，正在克隆仓库..."
    cd "$CLONE_DIR" || exit
    git clone "$REPO_URL"
    cd "$REPO_NAME" || exit
fi

# 运行构建命令
echo "🛠️ 正在执行 pnpm build..."
# 检查是否安装了 pnpm
if command -v pnpm &> /dev/null; then
    # build 前运行 install，确保依赖是最新的
    pnpm install && pnpm run build
else
    echo "❌ 错误: 未检测到 pnpm，请先安装 Node.js 和 pnpm。"
    exit 1
fi

# 目标文件路径
FONT_DEST="$HOME/Library/Fonts/sketchybar-app-font.ttf"
HELPER_DEST="$SCRIPT_DIR/helpers/app_icons.lua"

echo "🚚 正在同步生成的资源..."

# 检查 dist 目录是否生成成功
if [ -d "./dist" ]; then
    # 替换字体文件
    if [ -f "./dist/sketchybar-app-font.ttf" ]; then
        cp -f "./dist/sketchybar-app-font.ttf" "$FONT_DEST"
        echo "✅ 字体已更新: $FONT_DEST"
    fi

    # 替换 Lua 映射文件
    if [ -f "./dist/icon_map.lua" ]; then
        # 确保目标文件夹存在
        mkdir -p "$(dirname "$HELPER_DEST")"
        cp -f "./dist/icon_map.lua" "$HELPER_DEST"
        echo "✅ 映射文件已更新: $HELPER_DEST"
    fi
else
    echo "❌ 错误: 构建失败，未找到 dist 目录。"
    exit 1
fi

# Install SbarLua (Lua bindings for SketchyBar)
echo ""
echo "📦 Installing SbarLua..."
if [ -d "$HOME/.local/share/sketchybar_lua" ]; then
    echo "✅ SbarLua already installed"
else
    (git clone https://github.com/FelixKratz/SbarLua.git /tmp/SbarLua && cd /tmp/SbarLua/ && make install && rm -rf /tmp/SbarLua/)
    echo "✅ SbarLua installed to ~/.local/share/sketchybar_lua/"
fi


# Install Lua dependencies for AeroSpaceLua
echo ""
echo "📦 Installing Lua dependencies..."

# lua-cjson (JSON parsing)
if luarocks  list --porcelain lua-cjson | grep -q "lua-cjson"; then
    echo "✅ lua-cjson already installed"
else
    luarocks install lua-cjson  --local
fi


# Compile C helpers (menus, cpu_load, network_load)
echo ""
echo "📦 Compiling C helpers..."
HELPERS_DIR="$SCRIPT_DIR/helpers"

if [ -d "$HELPERS_DIR/menus" ]; then
    echo "   - Compiling menu helper..."
    cd "$HELPERS_DIR/menus"
    make clean 2>/dev/null || true
    make
    echo "   ✅ Menu helper compiled"
fi

if [ -d "$HELPERS_DIR/event_providers/cpu_load" ]; then
    echo "   - Compiling cpu_load helper..."
    cd "$HELPERS_DIR/event_providers/cpu_load"
    make clean 2>/dev/null || true
    make
    echo "   ✅ CPU load helper compiled"
fi

if [ -d "$HELPERS_DIR/event_providers/network_load" ]; then
    echo "   - Compiling network_load helper..."
    cd "$HELPERS_DIR/event_providers/network_load"
    make clean 2>/dev/null || true
    make
    echo "   ✅ Network load helper compiled"
fi


# Check if AeroSpace is installed (optional but recommended for workspaces)
echo ""
if ! command -v aerospace &> /dev/null; then
    echo "⚠️  AeroSpace not found (required for workspace management)"
    echo "   Install with: brew install --cask nikitabobko/tap/aerospace"
else
    echo "✅ AeroSpace installed"
fi

# Check for jq (optional, but useful for debugging)
if ! command -v jq &> /dev/null; then
    echo ""
    echo "💡 Optional: Install jq for JSON debugging"
    echo "   brew install jq"
fi

