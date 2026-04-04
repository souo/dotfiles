#!/usr/bin/env bash

set -e

HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# shellcheck source=./../utils.sh
# shellcheck disable=SC1091
. "$HERE/../utils.sh"
# shellcheck source=/dev/null
. "$HERE/utils.sh"

print_in_purple "arch setup"

update
"${HERE}"/locale.sh

"${HERE}"/build-essentials.sh
"${HERE}"/nvidia.sh
"${HERE}"/cmdline.sh
"${HERE}"/shell-script.sh
"${HERE}"/lesspipe.sh
"${HERE}"/git.sh
"${HERE}"/mise.sh
"${HERE}"/lua.sh
"${HERE}"/neovim.sh
"${HERE}"/fastfetch.sh
"${HERE}"/lazygit.sh
"${HERE}"/eza.sh
"${HERE}"/atuin.sh
"${HERE}"/dust.sh
"${HERE}"/lazydocker.sh
"${HERE}"/secure_tool.sh
