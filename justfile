# ==============================================================================
# 🎯 Justfile - Cross-platform Dotfiles Task Runner
# ==============================================================================

set shell := ["bash", "-c"]
set windows-shell := ["powershell", "-Command"]

# List available recipes
default:
    @just --list --justfile {{justfile()}}

# --- 🚀 Installation ---

# 初始化工作区基础空目录 (替代 Dotbot create:)
[private]
init-dirs:
    @mkdir -p ~/.local/share ~/.config ~/code/projects ~/code/clones ~/code/templates ~/code/workspaces ~/code/assets_library

# 执行 Profile 对应的后置构建钩子 (替代 Dotbot shell:)
[private]
post-install profile:
    #!/usr/bin/env bash
    set -euo pipefail
    DOTFILES="{{justfile_directory()}}"

    # 1. Bat cache 构建
    case "{{profile}}" in
      mac|server|wsl)
        command -v bat >/dev/null 2>&1 && bat cache --build || true
        ;;
      ubuntu)
        command -v batcat >/dev/null 2>&1 && batcat cache --build || true
        ;;
    esac

    # 2. Tmux 插件初始化
    case "{{profile}}" in
      mac|server|ubuntu|wsl)
        if command -v tmux >/dev/null 2>&1 && [ -f "$DOTFILES/config/tmux/config.sh" ]; then
          bash "$DOTFILES/config/tmux/config.sh" || true
        fi
        ;;
    esac

    # 3. Yazi 插件同步
    if command -v ya >/dev/null 2>&1 && [ -d "$HOME/.config/yazi" ]; then
      (cd "$HOME/.config/yazi" && ya pack -i) || true
    fi

    # 4. Zellij 环境初始化
    if command -v zellij >/dev/null 2>&1 && [ -f "$DOTFILES/config/zellij/setup.sh" ]; then
      bash "$DOTFILES/config/zellij/setup.sh" || true
    fi

# Deploy a system profile (e.g., just install mac)
[group('install')]
install profile="mac": init-dirs
    #!/usr/bin/env bash
    set -euo pipefail
    DOTFILES="{{justfile_directory()}}"
    CONFIGS=$(grep -vE '^\s*(#|$)' "$DOTFILES/meta/profiles/{{profile}}" \
      | sed "s|^|$DOTFILES/meta/configs/|" \
      | sed 's|$|.toml|' \
      | tr '\n' ':' \
      | sed 's/:$//')
    MISE_OVERRIDE_CONFIG_FILENAMES="$DOTFILES/meta/base.toml:${CONFIGS}" \
      mise bootstrap dotfiles apply --yes
    just post-install {{profile}}
    just check-links

# Dry-run a system profile deployment (no hooks, no side effects)
[group('install')]
dry-run profile="mac":
    #!/usr/bin/env bash
    set -euo pipefail
    DOTFILES="{{justfile_directory()}}"
    CONFIGS=$(grep -vE '^\s*(#|$)' "$DOTFILES/meta/profiles/{{profile}}" \
      | sed "s|^|$DOTFILES/meta/configs/|" \
      | sed 's|$|.toml|' \
      | tr '\n' ':' \
      | sed 's/:$//')
    MISE_OVERRIDE_CONFIG_FILENAMES="$DOTFILES/meta/base.toml:${CONFIGS}" \
      mise bootstrap dotfiles apply --dry-run --verbose

# Install standalone configurations (e.g., just standalone nvim zsh)
[group('install')]
standalone *configs:
    #!/usr/bin/env bash
    set -euo pipefail
    DOTFILES="{{justfile_directory()}}"
    CONFIG_LIST=""
    for cfg in {{configs}}; do
      CONFIG_LIST="${CONFIG_LIST}:$DOTFILES/meta/configs/${cfg}.toml"
    done
    MISE_OVERRIDE_CONFIG_FILENAMES="$DOTFILES/meta/base.toml${CONFIG_LIST}" \
      mise bootstrap dotfiles apply --yes

# --- 🧪 Testing ---

# Test the Ubuntu setup in an isolated Docker container
[group('test')]
test-ubuntu:
    docker run --rm -it \
        -v {{justfile_directory()}}:/root/.dotfiles \
        -w /root/.dotfiles \
        ubuntu:latest \
        bash -c "apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y git sudo curl python3 tzdata ca-certificates && ./setups/setup.sh ubuntu && ./install-profile.sh ubuntu && zsh"

# Update all submodules and perform full system maintenance (Topgrade)
[group('maint')]
update:
    git submodule update --init --recursive
    {{ if os() == "windows" { "topgrade" } else { "command -v topgrade >/dev/null && topgrade || echo 'Topgrade not found, skipping system update.'" } }}

# Run all quality checks (Lefthook)
[group('maint')]
lint:
    npx lefthook run pre-commit

# Check for orphaned symbolic links in home directory
[group('maint')]
check-links:
    #!/usr/bin/env bash
    set -euo pipefail
    DOTFILES="{{justfile_directory()}}"
    echo "🔍 Checking for orphaned dotfile links in ~ ..."
    found_dead=false
    while read -r link; do
      if [ ! -e "$link" ]; then
        echo "⚠️  Dead link: $link"
        found_dead=true
      fi
    done < <(find ~ -maxdepth 2 -type l -lname "*$DOTFILES*" 2>/dev/null || true)
    if [ "$found_dead" = false ]; then
      echo "✅ No dead links found."
    fi

# --- 📝 Development ---

# Create a new commit using conventional commits (cz)
[group('dev')]
commit:
    bun run commit

# Create a new changeset record
[group('dev')]
change:
    bun run change

# Bump versions and update CHANGELOG.md
[group('dev')]
version:
    bun run version

# --- 🔐 Secrets Management ---

# Initialize SOPS and generate Age key
[group('secrets')]
sops-init:
    ./bin/sops-init.sh

# Restore SOPS Age key from Bitwarden
[group('secrets')]
sops-restore:
    ./bin/sops-restore.sh

# Safely edit encrypted API keys and secrets
[group('secrets')]
secret-edit:
    SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt sops --input-type dotenv --output-type dotenv ./config/zsh/common/.env.secret.sops

# Decrypt variables into a local un-tracked zsh file
[group('secrets')]
secret-sync:
    @echo "set -a" > ~/.zsh_secret
    @SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt sops -d --input-type dotenv --output-type dotenv ./config/zsh/common/.env.secret.sops >> ~/.zsh_secret
    @echo "set +a" >> ~/.zsh_secret
    @echo "✅ Decrypted secrets applied to ~/.zsh_secret"

# Decrypt Claude settings into ~/.claude/settings.json
[group('secrets')]
claude-secret-sync:
	@SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt sops -d ./config/claude/settings.json.sops > ~/.claude/settings.json
	@echo "✅ Decrypted Claude settings applied to ~/.claude/settings.json"

# Safely edit encrypted Claude settings
[group('secrets')]
claude-secret-edit:
	SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt sops ./config/claude/settings.json.sops

# --- 🔧 Bootstrap ---

# One-time bootstrap for system dependencies
[group('setup')]
bootstrap:
    @{{ if os() == "windows" { "powershell -File ./Windows/setups/Setup.ps1" } else { "./setups/setup.sh" } }}

# --- 🎮 Neovim ---

# Reinstall Neovim from scratch (backup old config)
[group('nvim')]
nvim-reinstall:
    @REINSTALL=yes ./config/nvim/config.sh

# Sync Neovim plugins
[group('nvim')]
nvim-sync:
    @nvim --headless "+Lazy! sync" +qa

# Update vim-config core
[group('nvim')]
nvim-update:
    @cd ~/.config/nvim && git pull --rebase
    @echo "vim-config updated. Run 'just nvim-sync' to update plugins."

# Open plugin configuration
[group('nvim')]
nvim-config:
    @nvim ~/.config/nvim/lua/plugins/user-plugins.lua

# Check health
[group('nvim')]
nvim-health:
    @nvim --cmd "checkhealth" +qa
