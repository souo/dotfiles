#!/usr/bin/env bash

HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# shellcheck source=/dev/null
. "$HERE/utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Check if pipx is installed
if ! cmd_exists "cargo"; then
  echo "cargo is not installed. Please install rust first."
  exit 1
fi

# Function to install the app using cargo
install_cargo_package() {
  if cmd_exists "$2"; then
    print_success "$1"
  else
    execute \
      "cargo install $2" \
      "$1"
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

  print_in_purple "\n  cargo\n\n"

  install_cargo_package "zoxide" "zoxide"
  install_cargo_package "xplr" "yazi"
}

main
