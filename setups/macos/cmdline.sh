#!/usr/bin/env bash

set -e

HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# shellcheck source=/dev/null
. "$HERE/utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Command line tools\n"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

cmdline_tools=( wget curl git jq autojump bat fd fzf htop ripgrep zoxide shellcheck lazygit fastfetch)

for cmd in "${cmdline_tools[@]}"; do
    brew_install "$cmd" "$cmd"
done
