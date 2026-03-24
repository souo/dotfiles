#!/usr/bin/env bash

set -euo pipefail

HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# shellcheck disable=SC1091
. "$HERE"/../../setups/utils.sh

REINSTALL=${REINSTALL:-no}

ASTRONOMER_USER="${ASTRONOMER_USER:-AstroNvim}"
ASTRONOMER_REPO="${ASTRONOMER_REPO:-https://github.com/AstroNvim/template.git}"

setup_nvim_config() {
  local nvim_config_dir="$HOME/.config/nvim"

  if [ -d "$nvim_config_dir" ]; then
    if [ "$REINSTALL" = no ]; then
      # Check if it's an existing AstroNvim installation
      if [ -f "$nvim_config_dir/.git/HEAD" ]; then
        local current_remote
        current_remote=$(git -C "$nvim_config_dir" remote get-url origin 2>/dev/null || echo "")
        if [[ "$current_remote" == *"AstroNvim"* ]]; then
          print_success "Found existing AstroNvim installation, updating..."
          git -C "$nvim_config_dir" pull --rebase
          return 0
        fi
      fi
      # Not AstroNvim, backup and remove
      local backup_dir="$HOME/.config/nvim.backup.$(date +%Y%m%d_%H%M%S)"
      print_warning "Backing up existing nvim config to $backup_dir"
      mv "$nvim_config_dir" "$backup_dir"
    else
      print_warning "Removing existing nvim config"
      rm -rf "$nvim_config_dir"
    fi
  fi

  if [ ! -d "$nvim_config_dir" ]; then
    execute \
      "git clone --depth=1 ${ASTRONOMER_REPO} ${nvim_config_dir}" \
      "Cloning AstroNvim"
  fi
}

setup_user_plugins() {
  local user_config_dir="$HOME/.config/nvim/lua/plugins"
  mkdir -p "$user_config_dir"
  print_success "Ensured plugins directory exists"
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

  # Install Treesitter CLI if not present
  if ! command -v tree-sitter >/dev/null; then
    if command -v cargo >/dev/null; then
      cargo install tree-sitter-cli 2>/dev/null || true
    fi
  fi
}

sync_plugins() {
  print_in_purple "Syncing Neovim plugins..."
  if command -v nvim >/dev/null; then
    nvim --headless "+Lazy! sync" +qa 2>/dev/null || print_warning "Plugin sync failed (first run may take longer)"
  fi
}

main() {
  while [ $# -gt 0 ]; do
    case $1 in
      --reinstall) REINSTALL=yes ;;
      --user)
        shift
        ASTRONOMER_USER="$1"
        ;;
    esac
    shift
  done

  setup_nvim_config
  setup_user_plugins
  install_deps
  sync_plugins

  print_success "AstroNvim setup complete!"
  print_in_purple "Run 'nvim' to start. Press <leader>sp to open plugin spec."
}

main "$@"
