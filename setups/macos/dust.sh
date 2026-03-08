#!/usr/bin/env bash

HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# shellcheck source=/dev/null
. "$HERE/utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Dust (Disk Usage) \n"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Install du-dust via Homebrew
brew_install "Dust" "dust"
