#!/usr/bin/env bash

set -eu

HERE=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# shellcheck source=/dev/null
. "$HERE/utils.sh"

is_already_installed(){
    USER=${USER:-$(id -u -n)}
    HOME="${HOME:-$(eval echo ~"$USER")}"

    # Default value for $ZSH
    # a) if $ZDOTDIR is supplied and not $HOME: $ZDOTDIR/ohmyzsh
    # b) otherwise, $HOME/.oh-my-zsh
    if [ -n "$ZDOTDIR" ] && [ "$ZDOTDIR" != "$HOME" ]; then
        ZSH="${ZSH:-$ZDOTDIR/ohmyzsh}"
    fi
    ZSH="${ZSH:-$HOME/.oh-my-zsh}"

    [ -d "$ZSH" ]
}


install(){
    # shellcheck disable=SC2016
     execute \
        'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"' \
        "Install oh-my-zsh."
}

main(){
    if is_already_installed; then
        print_success "oh-my-zsh."
    else
        install
    fi
}


main
