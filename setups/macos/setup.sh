#!/usr/bin/env bash

set -eu

HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# shellcheck source=/dev/null
. "$HERE/../utils.sh"

# shellcheck source=/dev/null
. "$HERE/utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

"$HERE"/xcode.sh
"$HERE"/homebrew.sh
"$HERE"/browers.sh
"$HERE"/editor.sh
"$HERE"/terminals.sh
"$HERE"/fonts.sh
"$HERE"/python.sh
"$HERE"/lua.sh
"$HERE"/fnm.sh
"$HERE"/cmdline.sh
"$HERE"/../oh-my-zsh.sh
