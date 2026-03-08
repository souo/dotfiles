# ==============================================================================
# 🚀 Zsh Extreme Configuration (Powered by Antidote)
# Managed by Dotfiles: https://github.com/yourusername/dotfiles
# ==============================================================================

# Fast-path for non-interactive shells
[[ "$TERMINAL_CONTEXT" == "non-interactive" ]] && return

# 📂 Paths & Globals
export DOTFILES="$HOME/.dotfiles"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

# --- 📦 Antidote (Plugin Manager) ---
ANTIDOTE_DIR="$XDG_DATA_HOME/antidote"
[[ ! -d "$ANTIDOTE_DIR" ]] && git clone --depth=1 https://github.com/mattmc3/antidote.git "$ANTIDOTE_DIR"
source "$ANTIDOTE_DIR/antidote.zsh"

# Compile plugins.txt into a static .zsh file for peak performance
ANTIDOTE_PLUGINS_TXT="$DOTFILES/config/zsh/common/plugins.txt"
ANTIDOTE_PLUGINS_ZSH="$XDG_CACHE_HOME/antidote/plugins.zsh"

if [[ ! "$ANTIDOTE_PLUGINS_ZSH" -nt "$ANTIDOTE_PLUGINS_TXT" ]]; then
    mkdir -p "$(dirname "$ANTIDOTE_PLUGINS_ZSH")"
    antidote bundle < "$ANTIDOTE_PLUGINS_TXT" > "$ANTIDOTE_PLUGINS_ZSH"
fi
source "$ANTIDOTE_PLUGINS_ZSH"

# --- 🛠️ Core Environment (Dotbot Managed) ---

# Load exports first so tool-init can use them
[[ -f ~/.env ]] && source ~/.env
[[ -f ~/.aliases ]] && source ~/.aliases

# Local/Private overrides (NOT tracked by git)
for secret in ~/.{zsh_secret,localrc}; do
    [[ -r "$secret" ]] && source "$secret"
done
unset secret

# --- 🔧 Tool Initializations ---

# FZF initialization
source "$DOTFILES/config/fzf/.fzf.zsh"

# Oh My Posh (Prompt)
if command -v oh-my-posh >/dev/null; then
    eval "$(oh-my-posh init zsh --config "$DOTFILES/config/oh-my-posh/custom.omp.json")"
fi

# Zoxide (Better CD)
# zoxide
if command -v zoxide >/dev/null; then
    eval "$(zoxide init zsh)"
fi

# Atuin (Magical Shell History)
if command -v atuin >/dev/null; then
    # --disable-up-arrow: Keep default zsh up-arrow behavior if you prefer
    eval "$(atuin init zsh --disable-up-arrow)"
fi

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
if [[ -d "$PYENV_ROOT" ]]; then
    export PATH="$PYENV_ROOT/bin:$PATH"
    command -v pyenv >/dev/null && eval "$(pyenv init - zsh)"
fi

# --- ⚡ Optimized Completion (Compinit) ---
# Check for changes once a day
autoload -Uz compinit
for dump in "$HOME/.zcompdump"(N.m-1); do
  compinit -C
done
if [[ -z "$dump" ]]; then
  compinit
fi
unset dump

# --- ✨ System Info (Interactive only) ---
if [[ -o interactive ]] && command -v fastfetch >/dev/null; then
    fastfetch
fi
