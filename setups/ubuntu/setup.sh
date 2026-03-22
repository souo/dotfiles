#!/usr/bin/env bash

set -e

HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# shellcheck source=./../utils.sh
# shellcheck disable=SC1091
. "$HERE/../utils.sh"
# shellcheck source=/dev/null

. "$HERE/utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
update
upgrade

# Check if the system is running under WSL
if grep -qEi "(Microsoft|WSL)" /proc/version &> /dev/null; then
  print_in_purple "wsl ubuntu setup"
  "${HERE}"/build-essentials.sh
  "${HERE}"/cmdline.sh
  "${HERE}"/mise.sh
  "${HERE}"/python.sh
  "${HERE}"/zsh.sh
  "${HERE}"/dotnet.sh
  "${HERE}"/fastfetch.sh
  "${HERE}"/neovim.sh
else
  print_in_purple "ubuntu setup"
  "${HERE}"/build-essentials.sh
  "${HERE}"/cmdline.sh
  "${HERE}"/mise.sh
  "${HERE}"/python.sh
  "${HERE}"/zsh.sh
  "${HERE}"/browers.sh
  "${HERE}"/flatpak.sh
  "${HERE}"/dotnet.sh
  "${HERE}"/vscode.sh
  "${HERE}"/misc.sh
  "${HERE}"/terminals.sh
  "${HERE}"/fastfetch.sh
fi

"${HERE}"/dust.sh
"${HERE}"/atuin.sh
"${HERE}"/lazydocker.sh
"${HERE}"/lazygit.sh
"${HERE}"/eza.sh
"${HERE}"/cleanup.sh
