# GEMINI.md - Project Context & Instructions

This repository contains personal **dotfiles** managed with **Dotbot**, designed for high modularity and cross-platform compatibility (macOS, Ubuntu/WSL, Windows).

---

## 🎯 Project Overview

- **Management Tool**: [Dotbot](https://github.com/anishathalye/dotbot) (included as a git submodule).
- **Architecture**: **Fragmented Configuration**. Instead of a single `install.conf.yaml`, configuration is split into tool-specific fragments (`meta/configs/*.yaml`) and environment-specific profiles (`meta/profiles/*`).
- **Core Tech Stack**:
  - **Shell**: Zsh managed by **Antidote** (static plugin loading).
  - **Editor**: Neovim (automated dependency and plugin syncing).
  - **Terminal**: WezTerm.
  - **Automation**: Lefthook (Git hooks), Changesets (Versioning/Changelog).

---

## 🚀 Key Workflows

### 1. Deployment & Installation

- **Initialization**: Run `./setups/setup.sh` (Unix) or `.\Windows\setups\Setup.ps1` (Windows) for system-level dependencies.
- **Deploy Profile**: Use the custom wrapper to merge fragments:
  - `macOS`: `./install-profile.sh mac`
  - `Ubuntu`: `./install-profile.sh ubuntu`
  - `WSL`: `./install-profile.sh wsl`
  - `Windows`: `.\install-profile.ps1 windows`
- **Dry-run**: `./install-profile.sh --dry-run <profile>` to preview changes.

### 2. Maintenance & Development

- **New Config**: Add a YAML fragment to `meta/configs/` and update relevant profiles in `meta/profiles/`.
- **Commit**: Use `bun run commit` for conventional commit prompts.
- **Versioning**:
  - `bun run change`: Create a new changeset record.
  - `bun run version`: Bump version and update `CHANGELOG.md`.

### 3. Quality Control

- **Linting**: Lefthook automatically runs `shellcheck`, `yamllint`, and `markdownlint` on pre-commit.
- **Manual Lint**: `npx lefthook run pre-commit`.

---

## 🛡️ Security Standards

- **Secrets**: **NEVER** commit API keys or tokens.
- **Local Overrides**:
  - Use `~/.zsh_secret` for private tokens (sourced by `.zshrc`).
  - Use `~/.localrc` for machine-specific shell overrides.
  - VSCode uses `settings.common.json`; local overrides should be handled via the IDE or untracked `settings.local.json` logic.
- **Git**: Ensure `.gitignore` remains strict about `*.bak` and sensitive paths.

---

## 📂 Directory Structure Highlights

- `meta/configs/`: Dotbot YAML fragments.
- `meta/profiles/`: Lists of fragments defining a system profile.
- `config/`: Source configuration files (links point here).
- `setups/`: OS-specific bootstrap scripts.
- `bin/`: Custom CLI helpers and scripts.
- `.lefthook/`: Configuration for automated quality checks.

---

## 💡 Future Agent Instructions

- **Adding Configs**: Always check if a fragment already exists in `meta/configs/` before creating a new one.
- **Scripting**: All `.sh` scripts must pass `shellcheck` and include `set -euo pipefail`.
- **Modularity**: Prioritize splitting configurations into reusable parts rather than adding machine-specific logic to common files.
- **Verification**: Use the `--dry-run` flag in `install-profile.sh` to verify Dotbot pathing before suggesting final changes.
