#!/usr/bin/env bash

set -eu

HERE=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# shellcheck source=/dev/null
. "$HERE/utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Cleanup\n\n"

autoremove