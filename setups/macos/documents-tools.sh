#!/usr/bin/env bash

set -e

HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# shellcheck source=/dev/null

. "$HERE/utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n  documents tools\n"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# imagemagick
brew_install "ghostscript" "ghostscript"

# tectonic
brew_install "tectonic" "tectonic"

# mmdc
. "$HERE/../upkg.sh"

# bun add -g @mermaid-js/mermaid-cli
if cmd_exists "bun"; then
  install_bun_package "mermaid-cli" "@mermaid-js/mermaid-cli" "mmdc"
fi

