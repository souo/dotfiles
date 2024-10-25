#!/usr/bin/env bash


HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# shellcheck source=/dev/null
. "$HERE/utils.sh"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# JetBrainsMono Nerd Font
brew_install "JetBrainsMono Nerd Font" "font-jetbrains-mono-nerd-font"
