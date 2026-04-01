#!/usr/bin/env bash

HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# shellcheck source=/dev/null
. "$HERE/utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Secure Tool  \n"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Install SOPS + Age
brew_install "sops" "sops"
brew_install "age" "age"
