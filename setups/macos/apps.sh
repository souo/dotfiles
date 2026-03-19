#!/usr/bin/env bash

set -e

HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# shellcheck source=/dev/null
. "$HERE/utils.sh"

cask_apps=(1password raycast dash logseq notion obsidian tencent-lemon nikitabobko/tap/aerospace karabiner-elements)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Apps \n"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

for app in "${cask_apps[@]}"; do
    brew_install "$app" "$app" --cask
done
