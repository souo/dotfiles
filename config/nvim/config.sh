#!/usr/bin/env bash

set -euo pipefail

HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# shellcheck disable=SC1091
. "$HERE"/../../setups/utils.sh

REINSTALL=${REINSTALL:-no}

setup_nvim_config() {
  if [ -d "$HOME/.config/nvim" ]; then
    if [ "$REINSTALL" = no ]; then
      print_success "Found $HOME/.config/nvim keeping."
    else
      rm -rf "$HOME/.config/nvim"
      print_warning "$HOME/.config/nvim removed"
    fi
  fi

  if [ ! -d "$HOME/.config/nvim" ]; then
    execute \
      "git clone --depth=1 git@github.com:rafi/vim-config.git ~/.config/nvim" \
      "Cloning Neovim config"
  fi
}

install_deps() {
  print_in_purple "Checking Neovim dependencies..."
  
  if command -v pip3 >/dev/null; then
    pip3 install --user --upgrade pynvim 2>/dev/null || true
  fi

  if command -v bun >/dev/null; then
    bun install -g neovim 2>/dev/null || true
  elif command -v npm >/dev/null; then
    npm install -g neovim 2>/dev/null || true
  fi
}

sync_plugins() {
  print_in_purple "Syncing Neovim plugins..."
  # If using lazy.nvim, we can trigger a headless sync
  if [ -f "$HOME/.config/nvim/lua/config/lazy.lua" ] || [ -d "$HOME/.config/nvim/lua/plugins" ]; then
    nvim --headless "+Lazy! sync" +qa || true
  fi
}

main() {
  while [ $# -gt 0 ]; do
    case $1 in
      --reinstall) REINSTALL=yes ;;
    esac
    shift
  done

  setup_nvim_config
  install_deps
  sync_plugins
  
  print_success "Neovim setup complete!"
}

main "$@"
