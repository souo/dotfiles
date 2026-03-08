#!/usr/bin/env bash

set -e

HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# shellcheck source=./../utils.sh
. "$HERE/../utils.sh"
# shellcheck source=./../upkg.sh
. "$HERE/../upkg.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Dust (Disk Usage) \n"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Install du-dust via cargo (as standard package might not be in apt repo)
install_cargo_package "Dust" "du-dust" "dust"
