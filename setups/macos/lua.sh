#!/usr/bin/env bash

set -e

HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# shellcheck source=/dev/null
. "$HERE/utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   lua \n"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

brew_install "luarocks" "luarocks"
