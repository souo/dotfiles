#!/usr/bin/env bash

set -e

HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# shellcheck source=./../utils.sh
# shellcheck disable=SC1091
. "$HERE/../utils.sh"

update() {
    print_in_purple "\n • Update packages\n\n"
    sudo pacman -Syu --noconfirm
}

install_packages() {
    sudo pacman -S --needed --noconfirm "$@"
}
