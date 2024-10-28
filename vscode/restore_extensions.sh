#!/usr/bin/env bash

BASEDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# shellcheck disable=SC1091
. "$BASEDIR"/../setups/utils.sh

extensions_file="$BASEDIR/backupsvscode_extensions_macos"
installed="$(code --list-extensions | sort -biu)"


test_exist(){
  EXT_NAME="$1"
  for i in ${installed[@]}; do
    item=${installed[i]}
    if [ $item -eq $EXT_NAME ]; then
        unset 'installed[i]'
        return 0
    fi
  done
  return 1
}


while read -r line; do
  TO_INSTALL=$line
  if test_exist $TO_INSTALL; then
    print_success $TO_INSTALL
  else
    execute \
      "code --install-extension $TO_INSTALL" \
      "$TO_INSTALL"
  fi
done < ( cat $extensions_file | sort -biu )
