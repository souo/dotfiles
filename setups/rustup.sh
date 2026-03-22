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

execute "RUSTUP_DIST_SERVER=http://mirrors.tuna.tsinghua.edu.cn/rustup rustup install stable" "Install Rust"
