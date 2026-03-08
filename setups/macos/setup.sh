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

export HOMEBREW_API_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api"
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"

"$HERE"/set-defaults.sh
"$HERE"/xcode.sh
"$HERE"/shell_scripts.sh
"$HERE"/homebrew.sh
"$HERE"/browers.sh
"$HERE"/git.sh
"$HERE"/editor.sh
"$HERE"/terminals.sh
"$HERE"/fonts.sh
"$HERE"/python.sh
"$HERE"/lua.sh
"$HERE"/volta.sh
"$HERE"/cmdline.sh
"$HERE"/dust.sh
"$HERE"/atuin.sh
"$HERE"/lazydocker.sh
"$HERE"/karabiner.sh
"$HERE"/raycast.sh
"$HERE"/apps.sh
"$HERE"/zsh.sh
"$HERE"/image-tools.sh
"$HERE"/documents-tools.sh
