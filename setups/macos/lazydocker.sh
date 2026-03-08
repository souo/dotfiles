#!/usr/bin/env bash

HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# shellcheck source=/dev/null
. "$HERE/utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Lazydocker (Docker TUI) \n"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Install Lazydocker via Homebrew
brew_install "Lazydocker" "jesseduffield/lazydocker/lazydocker"
