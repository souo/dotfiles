#!/usr/bin/env bash

HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# shellcheck source=/dev/null
. "$HERE/utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Atuin (Shell History) \n"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Install Atuin via Homebrew
brew_install "Atuin" "atuin"
