# shellcheck shell=bash
# ==============================================================================
# 🌍 Environment Variables
# ==============================================================================

# --- 🌍 Localization ---
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# --- 📂 Path Management ---
# (Note: path is unique via typeset -U in zshrc)

# Homebrew (Smarter detection)
typeset -a brew_paths=(
    "/opt/homebrew/bin/brew"
    "/usr/local/bin/brew"
    "/home/linuxbrew/.linuxbrew/bin/brew"
)

for bp in "${brew_paths[@]}"; do
    if [[ -x "$bp" ]]; then
        eval "$($bp shellenv)"
        break
    fi
done
unset brew_paths bp

# Add essential custom bins to the front (only if they exist)
typeset -a custom_bins=(
    "$HOME/.local/bin"
    "$DOTFILES/bin"
    "$HOME/bin2/maven/bin"
    "$HOME/.cache/.bun/bin"
    "/opt/local/bin"
    "/opt/local/sbin"
)

typeset -a valid_bins
for b in "${custom_bins[@]}"; do
    [[ -d "$b" ]] && valid_bins+=("$b")
done
# shellcheck disable=SC2206
path=("${valid_bins[@]}" $path)
unset custom_bins b valid_bins

# --- 📝 Editors (Check after PATH is configured) ---
if command -v nvim >/dev/null; then
    export EDITOR='nvim'
    export VISUAL='nvim'
else
    export EDITOR='vim'
    export VISUAL='vim'
fi
export PAGER='less'

# --- 📦 Tool Configs ---
export EZA_CONFIG_DIR="$XDG_CONFIG_HOME/eza"
export LESS="-g -i -M -R -S -w -z-4 -F -X"
[[ -x /usr/local/bin/lesspipe.sh ]] && export LESSOPEN="|/usr/local/bin/lesspipe.sh %s"

# FZF Theme (OneDark/Catppuccin-ish)
export FZF_DEFAULT_OPTS='--color=fg:-1,fg+:#ffffff,bg:-1,bg+:#3c4048 --color=hl:#5ea1ff,hl+:#5ef1ff,info:#ffbd5e,marker:#5eff6c --color=prompt:#ff5ef1,spinner:#bd5eff,pointer:#ff5ea0,header:#5eff6c --color=gutter:-1,border:#3c4048,scrollbar:#7b8496,label:#7b8496 --color=query:#ffffff --border="rounded" --border-label="" --preview-window="hidden" --height 40%'

if command -v fd >/dev/null 2>&1; then
    export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
elif command -v rg >/dev/null 2>&1; then
    export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git/*"'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

# --- 🇨🇳 Mirror Settings (Tsinghua/NPM Mirror) ---
export NODE_MIRROR="https://mirrors.tuna.tsinghua.edu.cn/nodejs-release/"

export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
export HOMEBREW_INSTALL_FROM_API=1
export HOMEBREW_API_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api"
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"

export PYTHON_BUILD_MIRROR_URL="https://registry.npmmirror.com/-/binary/python"
export PYTHON_BUILD_MIRROR_URL_SKIP_CHECKSUM=1
export RUSTUP_UPDATE_ROOT="https://rsproxy.cn/rustup"
export RUSTUP_DIST_SERVER="https://rsproxy.cn"
export GO111MODULE=on
export GOPROXY=https://goproxy.cn


export PATH="$HOME/.agentmemory/bin:$HOME/.local/bin:$PATH"
