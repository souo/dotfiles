#!/usr/bin/env bash

set -e

# Check if .env exists and add env there too
if [ -f "$HOME/.env" ]; then
    if ! grep -q "export RUSTUP_UPDATE_ROOT=" "$HOME/.env" 2>/dev/null; then
        echo "" >> "$HOME/.env"
        echo "export RUSTUP_UPDATE_ROOT=https://mirrors.tuna.tsinghua.edu.cn/rustup/rustup" >> "$HOME/.env"
    fi

    if ! grep -q "RUSTUP_DIST_SERVER=" "$HOME/.env" 2>/dev/null; then
        echo "export RUSTUP_DIST_SERVER=https://mirrors.tuna.tsinghua.edu.cn/rustup" >> "$HOME/.env"
    fi
fi

