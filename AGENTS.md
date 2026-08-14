# GEMINI.md - Dotfiles Context & Instructions

This repository contains a modular, cross-platform **dotfiles** system managed with **Mise `[dotfiles]`** and automated via **just**. It supports macOS, Arch Linux, Headless/Server Linux, WSL, and Windows.

---

## 🎯 Project Overview

- **Core Tool**: [Mise `[dotfiles]`](https://mise.jdx.dev/) — built-in dotfiles manager that creates symlinks and runs hooks from TOML config files.
- **Architecture**: **Flat Platform Configuration**.
  - **Platform Configs**: Self-contained configuration files in `meta/<platform>.toml` (e.g., `mac.toml`, `arch.toml`, `server.toml`, `windows.toml`, `wsl.toml`).
  - **Unified Deployment**: `just install <profile>` deploys platform configs directly via `MISE_OVERRIDE_CONFIG_FILENAMES`.
- **Tech Stack Highlights**:
  - **Shell**: Zsh managed by **Antidote**.
  - **Editor**: Neovim (rafi/vim-config distribution).
  - **Terminal**: WezTerm + Zellij.
  - **macOS UI**: AeroSpace (Tiling WM) + SketchyBar (Status Bar) + JankyBorders.
  - **CLI Tools**: `fzf`, `zoxide`, `atuin`, `eza`, `bat`, `yazi`, `lazygit`.

---

## 🚀 Key Workflows

### 1. Installation & Deployment

- **Bootstrap**: Run `just bootstrap` to install system dependencies and initialize submodules.
- **Deploy Profile**:
  - macOS: `just install mac`
  - Arch Linux: `just install arch`
  - Headless/Server: `just install server`
  - WSL: `just install wsl`
  - Windows: `just install windows`
- **Dry-run**: `just dry-run <profile>` to preview changes without applying them.

### 2. Maintenance & Updates

- **Sync Everything**: `just update` (updates submodules and runs `topgrade`).
- **Check Links**: `just check-links` to find orphaned symbolic links in your home directory.
- **Neovim Management**:
  - `just nvim-sync`: Sync plugins.
  - `just nvim-reinstall`: Fresh reinstall of Neovim config.
- **Linting**: `just lint` (runs `shellcheck`, `yamllint`, and `markdownlint` via Lefthook).

### 3. Development

- **Config Management**: Add or update link mappings directly within the appropriate platform file in `meta/<platform>.toml`.
- **Commits**: Use `just commit` for interactive conventional commit prompts.
- **Versioning**:
  - `just change`: Create a new changeset.
  - `just version`: Bump version and update `CHANGELOG.md`.

---

## 🛡️ Security & Local Overrides

**NEVER** commit secrets. Use these untracked local files for sensitive or machine-specific data:

- `~/.zsh_secret`: API keys and tokens.
- `~/.localrc`: Machine-specific shell aliases/overrides.
- `~/.gitconfig.local`: Personal Git identity (`name`, `email`).
- `vscode/settings.local.json`: Machine-specific VSCode settings.

---

## 📂 Directory Structure

- `config/`: Source configuration files (symlinked by Mise).
- `meta/`: Platform-specific Mise `[dotfiles]` configuration files (`mac.toml`, `arch.toml`, `server.toml`, `windows.toml`, `wsl.toml`).
- `setups/`: OS-specific bootstrap and package installation scripts.
- `bin/`: Custom helper scripts and CLI utilities.
- `.lefthook/`: Git hook configurations for quality control.

---

## 💡 Agent Instructions

- **Adding / Updating Configs**: Edit platform files directly in `meta/` (e.g., `meta/mac.toml`, `meta/arch.toml`). Keep symlink definitions clean and relative.
- **Shell Scripts**: Must include `set -euo pipefail` and pass `shellcheck`.
- **Verification**: When suggesting changes to deployment logic, use `just dry-run <profile>` to verify.
- **Submodules**: Some configs are submodules; use `git submodule` commands when necessary.
