# shellcheck shell=bash
# ==========================================
# 游戏资产管理函数 (Game Asset Functions)
# ==========================================

# 默认资产库目录
export ASSETS_LIBRARY_DIR="${ASSETS_LIBRARY_DIR:-$HOME/code/assets_library}"

# 初始化资产库目录
ga_init() {
    local assets_dir="${1:-$ASSETS_LIBRARY_DIR}"
    echo "🚀 开始在 $assets_dir 检查并初始化游戏资产库..."

    mkdir -p "$assets_dir/2D_Art/"{UI_Elements,Tilesets,Characters,Backgrounds}
    mkdir -p "$assets_dir/3D_Models"
    mkdir -p "$assets_dir/Audio/"{Music,SFX,Ambient}
    mkdir -p "$assets_dir/Plugins_and_Tools"
    mkdir -p "$assets_dir/VFX_Particles"
    mkdir -p "$assets_dir/References"

    echo "✨ 资产库目录结构就绪！"
}

# 安全创建资产软链接
ga_link() {
    if [ "$#" -ne 2 ]; then
        echo "用法: ga_link <源文件或目录> <目标项目目录>"
        return 1
    fi

    local src="$1"
    local dest="$2"

    if [ ! -e "$src" ]; then
        echo "❌ 错误: 找不到源资产 '$src'"
        return 1
    fi

    # 获取绝对路径
    local abs_src
    abs_src="$(cd "$(dirname "$src")" && pwd)/$(basename "$src")"

    mkdir -p "$dest"
    ln -sf "$abs_src" "$dest/"
    echo "🔗 成功链接: $(basename "$src") -> $dest/"
}

# 纯净解压素材包
ga_unzip() {
    if [ "$#" -ne 2 ]; then
        echo "用法: ga_unzip <素材包.zip> <解压目标文件夹>"
        return 1
    fi

    local zip_file="$1"
    local dest_dir="$2"

    if ! command -v unzip >/dev/null 2>&1; then
        echo "❌ 错误: 系统未安装 'unzip' 工具。"
        return 1
    fi

    echo "📦 正在解压并过滤无用文件..."
    mkdir -p "$dest_dir"
    unzip -q "$zip_file" -d "$dest_dir" -x "*Demo*" "*Documentation*" "*.pdf" "*.txt" "*.md" "__MACOSX/*" "*/.DS_Store"

    echo "✅ 纯净解压完成: $dest_dir"
}
