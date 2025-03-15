#!/usr/bin/env bash

set -e

HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# shellcheck source=/dev/null
. "$HERE/../utils.sh"

# shellcheck source=/dev/null
. "$HERE/utils.sh"

if ! [[ $is_ubuntu_desktop ]]; then
  exit
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Terminals\n"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if ! package_is_installed "wezterm"; then
  curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /etc/apt/keyrings/wezterm-fury.gpg || print_error "wezterm (add key)"
  echo 'deb [signed-by=/etc/apt/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list || print_error "wezterm(add to package resource list)"
  update &>/dev/null || print_error "wezterm (resync package index files)"
fi

install_package "Wezterm" "wezterm"
