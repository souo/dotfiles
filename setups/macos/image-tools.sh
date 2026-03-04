#!/usr/bin/env bash

set -e

HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# shellcheck source=/dev/null
. "$HERE/utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Images tools\n"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# imagemagick
brew_install "imagemagick" "imagemagick"

# https://github.com/atanunq/viu
brew_install "viu" "viu"
