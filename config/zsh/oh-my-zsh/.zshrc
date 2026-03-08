# ==============================================================================
# 🚀 Zsh Extreme Configuration (Zero-Delay Ready)
# Optimized with zsh-defer and antidote
# ==============================================================================

# Fast-path for non-interactive shells
[[ "$TERMINAL_CONTEXT" == "non-interactive" ]] && return

# 📂 Paths & Globals
export DOTFILES="$HOME/.dotfiles"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

# --- ⚡ Optimized Completion (Compinit) ---
# MUST be loaded before plugins that use compdef
autoload -Uz compinit
for dump in "$HOME/.zcompdump"(N.m-1); do
  compinit -C
done
if [[ -z "$dump" ]]; then
  compinit
fi
unset dump

# --- 📦 Antidote (Plugin Manager) ---
ANTIDOTE_DIR="$XDG_DATA_HOME/antidote"
[[ ! -d "$ANTIDOTE_DIR" ]] && git clone --depth=1 https://github.com/mattmc3/antidote.git "$ANTIDOTE_DIR"
source "$ANTIDOTE_DIR/antidote.zsh"

# Compile plugins.txt into a static .zsh file
ANTIDOTE_PLUGINS_TXT="$DOTFILES/config/zsh/common/plugins.txt"
ANTIDOTE_PLUGINS_ZSH="$XDG_CACHE_HOME/antidote/plugins.zsh"

if [[ ! "$ANTIDOTE_PLUGINS_ZSH" -nt "$ANTIDOTE_PLUGINS_TXT" ]]; then
    mkdir -p "$(dirname "$ANTIDOTE_PLUGINS_ZSH")"
    antidote bundle < "$ANTIDOTE_PLUGINS_TXT" > "$ANTIDOTE_PLUGINS_ZSH"
fi
source "$ANTIDOTE_PLUGINS_ZSH"

# --- 🛠️ Core Environment (Immediate Load) ---
[[ -f ~/.env ]] && source ~/.env
[[ -f ~/.aliases ]] && source ~/.aliases
for secret in ~/.{zsh_secret,localrc}; do
    [[ -r "$secret" ]] && source "$secret"
done
unset secret

# --- 🔧 Tool Initializations (DEFERRED for zero delay) ---
# We use zsh-defer to keep the initial prompt appearing instantly

# Oh My Posh (Prompt) - Needs to be fast, but can be slightly deferred
if command -v oh-my-posh >/dev/null; then
    eval "$(oh-my-posh init zsh --config "$DOTFILES/config/oh-my-posh/custom.omp.json")"
fi

# Defer non-critical tools
if command -v zsh-defer >/dev/null; then
    # Zoxide (Better CD)
    zsh-defer -c '[[ -n "$(command -v zoxide)" ]] && eval "$(zoxide init zsh)"'
    
    # Atuin (Magical Shell History)
    zsh-defer -c '[[ -n "$(command -v atuin)" ]] && eval "$(atuin init zsh --disable-up-arrow)"'
    
    # FZF initialization
    zsh-defer source "$DOTFILES/config/fzf/.fzf.zsh"
    
    # Pyenv
    zsh-defer -c 'export PYENV_ROOT="$HOME/.pyenv"; [[ -d "$PYENV_ROOT" ]] && export PATH="$PYENV_ROOT/bin:$PATH" && command -v pyenv >/dev/null && eval "$(pyenv init - zsh)"'
    
    # System Info
    zsh-defer -c '[[ -o interactive ]] && command -v fastfetch >/dev/null && fastfetch'
else
    # Fallback if zsh-defer is not available yet
    [[ -f "$DOTFILES/config/fzf/.fzf.zsh" ]] && source "$DOTFILES/config/fzf/.fzf.zsh"
    [[ -n "$(command -v zoxide)" ]] && eval "$(zoxide init zsh)"
fi
