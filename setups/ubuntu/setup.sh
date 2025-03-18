#!/usr/bin/env bash

set -e

HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# shellcheck source=/dev/null
. "$HERE/utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
update
upgrade

"${HERE}"/build-essentials.sh
"${HERE}"/cmdline.sh
"${HERE}"/browers.sh
"${HERE}"/flatpak.sh
"${HERE}"/dotnet.sh
"${HERE}"/vscode.sh
"${HERE}"/misc.sh
"${HERE}"/terminals.sh
"${HERE}"/zsh.sh
"${HERE}"/cleanup.sh
