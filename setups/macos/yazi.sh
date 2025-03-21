#!/usr/bin/env bash

set -e

HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# shellcheck source=/dev/null
. "$HERE/utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n  yazi\n"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

brew_install 'yazi' 'yazi'
