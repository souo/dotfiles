#!/usr/bin/env bash

set -e

HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# shellcheck source=/dev/null
. "$HERE/utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Terminals\n"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# wezterm
brew_install "wezterm" "wezterm"

# tmux
brew_install "tmux" "tmux"

# tmux-MacOSX-pasteboard
brew_install "tmux MacOSX pasteboard" "reattach-to-user-namespace"
