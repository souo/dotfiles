# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# no more asking to update!
DISABLE_UPDATE_PROMPT=true

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
if [[ "$(uname -s)" == 'Darwin' ]]; then
    plugins=(git macos brew docker tmux)
fi
if [[ "$(uname -s)" == 'Linux' ]]; then
    plugins=(git docker nmap tmux)
fi

ZSH_THEME=""

if [[ -e ~/.localrc ]]; then
    source ~/.localrc
fi

for file in ~/.{aliases,env}; do
    if [[ -r "$file" ]] && [[ -f "$file" ]]; then
        # shellcheck source=/dev/null
        source "$file"
    fi
done
unset file

source $ZSH/oh-my-zsh.sh

eval "$(oh-my-posh init zsh --config $DOTFILES/zsh/pure.omp.json)"

eval "$(zoxide init zsh)"

eval "$(fnm env --use-on-cd --shell zsh)"

if brew list "zsh-autosuggestions" &>/dev/null; then
    source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# https://github.com/zsh-users/zsh-syntax-highlighting?tab=readme-ov-file#why-must-zsh-syntax-highlightingzsh-be-sourced-at-the-end-of-the-zshrc-file
if brew list "zsh-syntax-highlighting" &>/dev/null; then
    source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

fastfetch
