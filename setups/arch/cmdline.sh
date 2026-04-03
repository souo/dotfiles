#!/usr/bin/env bash
set -e
HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
# shellcheck disable=SC1091
. "$HERE/utils.sh"
print_in_purple "\n • Installs cmdline tools\n\n"
install_packages bat fzf tmux zellij ripgrep fd yazi htop unzip zip tar jq tokei shellcheck tree-sitter-cli