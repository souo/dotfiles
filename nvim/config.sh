#!/usr/bin/env bash

set -eu

HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# shellcheck disable=SC1091
. "$HERE"/../setups/utils.sh


#'yes' means will reinstall tmux config from github repo
REINSTALL=${REINSTALL:-no}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

setup_nvim() {
    if [ -d "$HOME/.config/nvim" ]; then
        if [ "$REINSTALL" = no ]; then
            print_success "Found $HOME/.config/nvim keeping."
            return
        else
            rm -rf "$HOME/.config/nvim" && print_warning "$HOME/.config/nvim successfully removed"
        fi
    fi
    execute \
        "cd ~ && git clone git@github.com:rafi/vim-config.git ~/.config/nvim" \
        "Cloning tmux config"

}

main() {
    #Parse arguments
    while [ $# -gt 0 ]; do
        case $1 in
        --reinstall) REINSTALL=yes ;;
        esac
        shift
    done
    print_in_purple "\n  config nvim \n"
    setup_nvim
}

main "$@"
