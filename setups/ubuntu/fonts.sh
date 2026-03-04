#!/usr/bin/env bash

set -e

HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# shellcheck source=/dev/null
. "$HERE/../utils.sh"

if ! [[ $is_ubuntu_desktop ]]; then
  exit
fi

print_in_purple "Install font for desktop"
