#!/usr/bin/env bash
set -e

HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
# shellcheck disable=SC1091
. "$HERE/utils.sh"

print_in_purple "\n • Installs lesspipe\n\n"

if ! command -v lesspipe.sh >/dev/null; then
  # Ensure make and perl are installed
  install_package "make" "make"
  install_package "perl" "perl"

  TMP_DIR=$(mktemp -d "/tmp/lesspipe-XXXXXXXX")
  
  execute "git clone --depth 1 https://github.com/wofr06/lesspipe $TMP_DIR/lesspipe" "Cloning lesspipe repo"
  cd "$TMP_DIR/lesspipe" || exit 1
  execute "./configure" "Configuring lesspipe"
  execute "make" "Making lesspipe"
  execute "sudo make install" "Installing lesspipe (requires sudo)"

  cd "$HERE" || exit 1
  rm -rf "$TMP_DIR"
else
  print_success "lesspipe already installed"
fi
