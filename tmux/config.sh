#!/usr/bin/env bash

set -eu

HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# shellcheck disable=SC1091
. "$HERE"/../setups/utils.sh

#'yes' means will not replace an existing .tmux.conf and .tmux.conf.local(default: no)
RELINK=${RELINK:-no}

#'yes' means will reinstall tmux config from github repo
REINSTALL=${REINSTALL:-no}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

setup_tmux() {
    if [ -d "$HOME/.tmux" ]; then
        if [ "$REINSTALL" = no ]; then
            print_success "Found $HOME/.tmux, keeping."
            return
        else
            rm -rf "$HOME/.tmux" && print_warning "$HOME/.tmux successfully removed"
        fi
    fi
    execute \
        "cd ~ && git clone https://github.com/gpakosz/.tmux.git  ~/.tmux" \
        "Cloning tmux config"

}

link_tmux_config() {
    if [ -f "$HOME/.tmux.conf" ] || [ -h "$HOME/.tmux.conf" ]; then
        if [ "$RELINK" = no ]; then
            print_success "Found $HOME/.tmux.conf, keeping."
            return
        fi
    fi

    execute \
        "cd ~ && ln -s -f .tmux/.tmux.conf" \
        "link tmux.conf"

}

link_tmux_config_local() {
    if [ -f "$HOME/.tmux.conf.local" ] || [ -h "$HOME/.tmux.conf.local" ]; then
        if [ "$RELINK" = no ]; then
            print_success "Found $HOME/.tmux.conf.local, keeping."
            return
        fi
    fi
    execute \
        "ln -s -f $HERE/.tmux.conf.local  $HOME/.tmux.conf.local" \
        "link tmux.conf.local"
}

main() {
    #Parse arguments
    while [ $# -gt 0 ]; do
        case $1 in
        --reinstall) REINSTALL=yes ;;
        --relink) RELINK=yes ;;
        esac
        shift
    done
    print_in_purple "\n  config tmux \n"
    setup_tmux
    link_tmux_config
    link_tmux_config_local
}

main "$@"
