#!/usr/bin/env bash

set -e

HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# shellcheck source=/dev/null
. "$HERE/../utils.sh"

# shellcheck source=/dev/null
. "$HERE/utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Macos \n"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
printf "\n"

"$HERE"/xcode.sh
"$HERE"/homebrew.sh
"$HERE"/browsers.sh
"$HERE"/editor.sh
"$HERE"/terminals.sh
"$HERE"/fonts.sh
"$HERE"/python.sh
"$HERE"/lua.sh
"$HERE"/fnm.sh
"$HERE"/cmdline.sh
"$HERE"/apps.sh
"$HERE"/zsh.sh
