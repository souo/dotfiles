#!/usr/bin/env bash

set -e

HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# shellcheck source=/dev/null
. "$HERE/utils.sh"


cask_apps=(1password Bartender)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Apps \n"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

for app in "${cask_apps[@]}"; do
    brew_install "$app" "$app" --cask
done
