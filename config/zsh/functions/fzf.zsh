# shellcheck disable=SC2148
# ==============================================================================
# 🔍 FZF Enhanced Functions
# ==============================================================================

# --- 📄 fp (File Preview) ---
# Fuzzy find files and preview them with bat
# Usage: fp [directory]
fp() {
    local dir="${1:-.}"
    local cmd
    if command -v fd >/dev/null 2>&1; then
        cmd="fd --type f --hidden --follow --exclude .git . \"$dir\""
    else
        cmd="find \"$dir\" -maxdepth 4 -not -path '*/.*'"
    fi

    local file
    file=$(eval "$cmd" | fzf \
        --preview '[[ -d {} ]] && eza --icons --tree --color=always {} | head -200 || bat --style=numbers --color=always --line-range :500 {}' \
        --preview-window=right:60% \
        --header "🔍 Preview (Enter: Open with $EDITOR | Alt-E: Edit)" \
        --bind "alt-e:execute($EDITOR {})+accept")
    
    [[ -n "$file" ]] && ${EDITOR:-nvim} "$file"
}

# --- 📁 fz (Fuzzy Directory) ---
# Fuzzy find directories and cd into them
# Uses zoxide if available for smarter jumping
fz() {
    local dir
    if command -v zoxide >/dev/null 2>&1; then
        dir=$(zoxide query -l | fzf --height 40% --reverse --header "🚀 Jump to directory (Zoxide)" --preview 'eza --icons --tree --color=always {} | head -200')
    else
        local cmd
        if command -v fd >/dev/null 2>&1; then
            cmd="fd --type d --hidden --follow --exclude .git"
        else
            cmd="find . -maxdepth 3 -type d -not -path '*/.*'"
        fi
        dir=$(eval "$cmd" | fzf --height 40% --reverse --header "📁 Select directory" --preview 'eza --icons --tree --color=always {} | head -200')
    fi
    [[ -n "$dir" ]] && cd "$dir" || return
}

# --- 💀 fkill (Fuzzy Kill) ---
# Select a process to kill with detailed info
fkill() {
    local pid
    if [[ "$UID" != "0" ]]; then
        pid=$(ps -f -u "$USER" | sed 1d | fzf -m --header "💀 Select process to kill" --preview 'echo {}' --preview-window=bottom:3:wrap | awk '{print $2}')
    else
        pid=$(ps -ef | sed 1d | fzf -m --header "💀 Select process to kill" --preview 'echo {}' --preview-window=bottom:3:wrap | awk '{print $2}')
    fi

    if [[ -n "$pid" ]]; then
        echo "$pid" | xargs kill -9
    fi
}

# --- 📦 fconf (Fuzzy Config) ---
# Quickly edit dotfiles
fconf() {
    local cmd
    if command -v fd >/dev/null 2>&1; then
        cmd="fd --type f --hidden --follow --exclude .git . \"$DOTFILES\""
    else
        cmd="find \"$DOTFILES\" -maxdepth 3 -not -path '*/.*'"
    fi

    local file
    file=$(eval "$cmd" | fzf --header "⚙️ Edit Dotfiles" --preview 'bat --style=numbers --color=always --line-range :500 {}')
    [[ -n "$file" ]] && ${EDITOR:-nvim} "$file"
}
