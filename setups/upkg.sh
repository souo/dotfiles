#!/usr/bin/env bash

# 获取脚本所在目录
HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# 引入工具函数 (假设包含 cmd_exists, execute, print_success)
# shellcheck source=/dev/null
if [ -f "$HERE/utils.sh" ]; then
  . "$HERE/utils.sh"
else
  echo "Error: utils.sh not found!"
  exit 1
fi

# ==============================================================================
# 环境预检
# ==============================================================================

check_requirements() {
  local missing_mgrs=()
  for mgr in pipx cargo npm bun; do
    if ! cmd_exists "$mgr"; then
      missing_mgrs+=("$mgr")
    fi
  done

  if [ ${#missing_mgrs[@]} -ne 0 ]; then
    echo "提示: 以下包管理器未安装，相关任务将被跳过: ${missing_mgrs[*]}"
  fi
}

# ==============================================================================
# 安装函数封装
# ==============================================================================

# 1. pipx (Python 工具隔离安装)
install_pipx_package() {
  # $1: 显示描述, $2: 包名, $3: 可执行文件名 (可选，默认同包名)
  local name=${3:-$2}
  if pipx list --short | grep -q "^$2 "; then
    print_success "$1"
  else
    execute "pipx install $2" "$1"
  fi
}

# 2. cargo (Rust)
install_cargo_package() {
  # $1: 显示描述, $2: 包名, $3: 可执行文件名 (可选，用于检测)
  local bin_name=${3:-$2}
  if cmd_exists "$bin_name"; then
    print_success "$1"
  else
    execute "cargo install $2" "$1"
  fi
}

# 3. npm (Node.js 全局)
install_npm_package() {
  # $1: 显示描述, $2: 包名, $3: 可执行文件名 (可选)
  local bin_name=${3:-$2}
  if cmd_exists "$bin_name"; then
    print_success "$1"
  else
    execute "npm install -g $2" "$1"
  fi
}

# 4. bun (JavaScript/TypeScript 高速工具)
install_bun_package() {
  # $1: 显示描述, $2: 包名, $3: 可执行文件名 (可选)
  local bin_name=${3:-$2}
  if cmd_exists "$bin_name"; then
    print_success "$1"
  else
    # 注意：bun global install 使用 'bun add -g'
    execute "bun add -g $2" "$1"
  fi
}

