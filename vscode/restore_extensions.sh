#!/usr/bin/env bash

set -e

BASEDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# shellcheck disable=SC1091
. "$BASEDIR"/../setups/utils.sh

while read -r item; do installed+=("$item");done <<< "$(code --list-extensions | sort )"

confirm_installed(){
  EXT_NAME=$1
  for i in "${!installed[@]}"; do
    item="${installed[$i]}"
    if [ "$item" = "$EXT_NAME" ]; then
        unset 'installed[i]'
        return 0
    fi
  done
  return 1
}

os=$(get_os)
extensions_file="$BASEDIR/backups/vscode_extensions_$os"

while read -r line; do
  TO_INSTALL=$line
  if confirm_installed "$TO_INSTALL"; then
    print_success "$TO_INSTALL"
  else
    execute \
      "code --install-extension $TO_INSTALL" \
      "$TO_INSTALL"
  fi
done  < "$extensions_file"
