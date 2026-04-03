#!/usr/bin/env bash
set -e
HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
# shellcheck disable=SC1091
. "$HERE/utils.sh"
print_in_purple "\n • Installs neovim\n\n"
install_packages neovim