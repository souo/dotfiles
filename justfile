# ==============================================================================
# 🎯 Justfile - Cross-platform Dotfiles Task Runner
# ==============================================================================

set shell := ["bash", "-c"]
set windows-shell := ["powershell", "-Command"]

# List available recipes
default:
    @just --list --justfile {{justfile()}}

# --- 🚀 Installation ---

# Deploy a system profile (e.g., just install mac)
[group('install')]
install profile="mac":
    {{ if os() == "windows" { "powershell -File ./install-profile.ps1 " + profile } else { "./install-profile.sh " + profile } }}

# Dry-run a system profile deployment
[group('install')]
dry-run profile="mac":
    {{ if os() == "windows" { "powershell -File ./install-profile.ps1 " + profile + " -DryRun" } else { "./install-profile.sh --dry-run " + profile } }}

# Install standalone configurations (e.g., just standalone nvim zsh)
[group('install')]
standalone *configs:
    {{ if os() == "windows" { "powershell -File ./install-standalone.ps1 " + configs } else { "./install-standalone.sh " + configs } }}

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
    @{{ if os() == "windows" { "powershell -File ./bin/check-dead-links.ps1" } else { "./install-profile.sh --dry-run base | grep 'dead link' || echo 'No dead links found.'" } }}

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
