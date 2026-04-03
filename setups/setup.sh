#!/usr/bin/env bash
set -e

HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# ----------------------------------------------------------------------
# | Main                                                               |
# ----------------------------------------------------------------------
main() {

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Load utils
  if [ -x "$HERE/utils.sh" ]; then
    # shellcheck disable=SC1091
    . "$HERE/utils.sh" || exit 1
  fi

  os_name="$(get_os)"

  if [[ ! ($os_name == 'macos' || $os_name == 'ubuntu' || $os_name == 'arch') ]]; then
    printf "Sorry, this script is intended only for macOS, Ubuntu, and Arch! \n"
    exit 1
  fi

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  ask_for_sudo

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  if [[ $os_name == 'macos' ]]; then
    "$HERE"/macos/setup.sh
  elif [[ $os_name == 'ubuntu' ]]; then
    "$HERE"/ubuntu/setup.sh
  elif [[ $os_name == 'arch' ]]; then
    "$HERE"/arch/setup.sh
  fi
}

main
