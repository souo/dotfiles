# GEMINI.md - Dotfiles Context & Instructions

This repository contains a modular, cross-platform **dotfiles** system managed with **Dotbot** and automated via **just**. It supports macOS, Arch Linux, Ubuntu/WSL, and Windows.

---

## 🎯 Project Overview

- **Core Tool**: [Dotbot](https://github.com/anishathalye/dotbot) (git submodule).
- **Architecture**: **Fragmented Configuration**.
  - **Fragments**: Individual tool configs in `meta/configs/*.yaml`.
  - **Profiles**: Environment-specific lists in `meta/profiles/` (e.g., `mac`, `server`, `ubuntu`, `wsl`).
  - **Unified Deployment**: `install-profile.sh` merges fragments into a single Dotbot execution for speed.
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
  - Arch Linux: `just install server`
  - Ubuntu: `just install ubuntu`
  - WSL: `just install wsl`
  - Windows: `just install windows`
- **Dry-run**: `just dry-run <profile>` to preview changes without applying them.
- **Standalone**: `just standalone <config> [extra...]` (e.g., `just standalone nvim zsh`).

### 2. Maintenance & Updates

- **Sync Everything**: `just update` (updates submodules and runs `topgrade`).
- **Check Links**: `just check-links` to find orphaned symbolic links in your home directory.
- **Neovim Management**:
  - `just nvim-sync`: Sync plugins.
  - `just nvim-reinstall`: Fresh reinstall of Neovim config.
- **Linting**: `just lint` (runs `shellcheck`, `yamllint`, and `markdownlint` via Lefthook).

### 3. Development

- **New Config**: Add a YAML fragment to `meta/configs/` and add its name to relevant profiles in `meta/profiles/`.
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

- `config/`: Source configuration files (symlinked by Dotbot).
- `meta/configs/`: Dotbot YAML fragments for specific tools.
- `meta/profiles/`: Definitions of system-wide profiles.
- `setups/`: OS-specific bootstrap and package installation scripts.
- `bin/`: Custom helper scripts and CLI utilities.
- `.lefthook/`: Git hook configurations for quality control.

---

## 💡 Agent Instructions

- **Adding Fragments**: Always check `meta/configs/` first. Follow the pattern in `meta/configs/nvim.yaml`.
- **Shell Scripts**: Must include `set -euo pipefail` and pass `shellcheck`.
- **Modularity**: Prefer small, reusable fragments over large, monolithic files.
- **Verification**: When suggesting changes to deployment logic, use `./install-profile.sh --dry-run` to verify.
- **Submodules**: Remember that `dotbot` and some configs are submodules; use `git submodule` commands when necessary.
