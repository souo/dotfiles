#!/usr/bin/env bash

set -e

# Check if .env.zsh exists and add env there too
if [ -f "$HOME/.env.zsh" ]; then
    if ! grep -q "export RUSTUP_UPDATE_ROOT=" "$HOME/.env.zsh" 2>/dev/null; then
        echo "" >> "$HOME/.env.zsh"
        echo "export RUSTUP_UPDATE_ROOT=https://mirrors.tuna.tsinghua.edu.cn/rustup/rustup" >> "$HOME/.env.zsh"
    fi

    if ! grep -q "RUSTUP_DIST_SERVER=" "$HOME/.env.zsh" 2>/dev/null; then
        echo "export RUSTUP_DIST_SERVER=https://mirrors.tuna.tsinghua.edu.cn/rustup" >> "$HOME/.env.zsh"
    fi
fi

