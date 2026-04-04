#!/usr/bin/env bash

set -e

HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# shellcheck source=/dev/null
. "$HERE/utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Secure Tool  \n"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Install SOPS + Age
install_packages "sops"
install_packages "age"
