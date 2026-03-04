# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
export DOTFILES="$HOME/.dotfiles"

# no more asking to update!
DISABLE_UPDATE_PROMPT=true

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
if [[ "$(uname -s)" == 'Darwin' ]]; then
    plugins=(git macos docker brew eza vscode fzf-tab fzf-tab-source)
fi
if [[ "$(uname -s)" == 'Linux' ]]; then
    plugins=(git eza vscode )
fi

zstyle ':omz:plugins:eza' 'icons' yes

ZSH_THEME=""

source $ZSH/oh-my-zsh.sh

if [[ "$(uname -s)" == 'Darwin' ]]; then

    eval "$(/opt/homebrew/bin/brew shellenv)"

    if brew list "zsh-autosuggestions" &>/dev/null; then
        source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    fi

    # https://github.com/zsh-users/zsh-syntax-highlighting?tab=readme-ov-file#why-must-zsh-syntax-highlightingzsh-be-sourced-at-the-end-of-the-zshrc-file
    if brew list "zsh-syntax-highlighting" &>/dev/null; then
        source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    fi
else
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

if [[ -e ~/.localrc ]]; then
    source ~/.localrc
fi

for file in ~/.{env,aliases}; do
    if [[ -r "$file" ]] && [[ -f "$file" ]]; then
        # shellcheck source=/dev/null
        source "$file"
    fi
done
unset file

source $DOTFILES/config/fzf/.fzf.zsh


# oh-my-posh
if [ "$(command -v oh-my-posh)" ]; then
    if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
        eval "$(oh-my-posh init zsh --config $DOTFILES/config/oh-my-posh/custom.omp.json)"
    fi
fi

if [ "$(command -v zoxide)" ]; then
    eval "$(zoxide init zsh)"
fi

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"

if [ "$(command -v pyenv)" ]; then
    eval "$(pyenv init - zsh)"
fi

fastfetch
