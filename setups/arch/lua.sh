#!/usr/bin/env bash
set -e
HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
# shellcheck disable=SC1091
. "$HERE/utils.sh"
print_in_purple "\n • Installs lua & luarocks\n\n"
install_packages lua luarocks