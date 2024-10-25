#!/usr/bin/env bash

set -e

HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# shellcheck source=/dev/null
. "$HERE/utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Editors\n"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# neovim
brew_install "neovim" "neovim"


# Install VSCode
brew_install "Visual Studio Code" "visual-studio-code" "--cask"
