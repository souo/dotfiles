#!/usr/bin/env bash

set -e

HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# shellcheck source=./../utils.sh
. "$HERE/../utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Lazydocker (Docker TUI) \n"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if ! cmd_exists "lazydocker"; then
  # Official one-liner or manual install
  # https://github.com/jesseduffield/lazydocker#installation
  LAZYDOCKER_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazydocker/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
  curl -Lo lazydocker.tar.gz "https://github.com/jesseduffield/lazydocker/releases/latest/download/lazydocker_${LAZYDOCKER_VERSION}_Linux_x86_64.tar.gz"
  mkdir -p temp_lazydocker
  tar xf lazydocker.tar.gz -C temp_lazydocker
  sudo install temp_lazydocker/lazydocker /usr/local/bin
  rm -rf temp_lazydocker lazydocker.tar.gz
  print_success "Lazydocker"
else
  print_success "Lazydocker"
fi
