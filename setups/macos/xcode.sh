#!/usr/bin/env bash

set -e

HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# shellcheck source=/dev/null
. "$HERE/../utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


are_xcode_command_line_tools_installed() {
    xcode-select --print-path &> /dev/null
}


install_xcode_command_line_tools() {

    if are_xcode_command_line_tools_installed; then
        print_success "Install Xcode Command Line Tools"
        exit
    fi

    # If necessary, prompt user to install
    # the `Xcode Command Line Tools`.

    xcode-select --install &> /dev/null

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Wait until the `Xcode Command Line Tools` are installed.

    execute \
        "until are_xcode_command_line_tools_installed; do \
            sleep 5; \
         done" \
        "Install Xcode Command Line Tools"

}


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    print_in_purple "   Xcode\n\n"

    install_xcode_command_line_tools

}

main
