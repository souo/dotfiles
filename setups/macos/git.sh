#!/usr/bin/env bash

set -e

HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# shellcheck source=/dev/null
. "$HERE/utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Command line tools\n"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

cmdline_tools=(git git-lfs git-delta difftastic lazygit)

for cmd in "${cmdline_tools[@]}"; do
  brew_install "$cmd" "$cmd"
done
