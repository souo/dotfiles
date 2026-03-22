#!/usr/bin/env bash

set -e

HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# shellcheck source=/dev/null
. "$HERE/utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Command line tools\n"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

cmdline_tools=(wget curl jq tokei bat fd fzf  ripgrep zellij shellcheck fastfetch rich eza tree-sitter-cli)

for cmd in "${cmdline_tools[@]}"; do
  brew_install "$cmd" "$cmd"
done
