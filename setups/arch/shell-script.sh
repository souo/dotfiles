#!/usr/bin/env bash
set -e
HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
# shellcheck disable=SC1091
. "$HERE/utils.sh"
print_in_purple "\n • Installs zsh\n\n"
install_packages zsh bash

if [ "$(basename "$SHELL")" != "zsh" ]; then
  print_in_purple "Setting default shell to zsh"
  chsh -s "$(command -v zsh)" || print_warning "Failed to set default shell. You may need to run 'chsh -s \$(command -v zsh)' manually."
fi

if ! command -v oh-my-posh &> /dev/null; then
  print_in_purple "\n • Installs oh-my-posh\n\n"
  execute "curl -s https://ohmyposh.dev/install.sh | bash -s" "Oh My Posh"
fi
