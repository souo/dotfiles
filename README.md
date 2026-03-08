# 🛠️ dotfiles

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Lefthook](https://img.shields.io/badge/git_hooks-lefthook-blue.svg)](https://github.com/evilmartians/lefthook)
[![Commitizen friendly](https://img.shields.io/badge/commitizen-friendly-brightgreen.svg)](http://commitizen.github.io/cz-cli/)
[![ShellCheck](https://img.shields.io/badge/shellcheck-enabled-brightgreen.svg)](https://www.shellcheck.net/)

My personal dotfiles, meticulously managed with **Dotbot**. This repository is designed to be modular, cross-platform, and highly automated, supporting macOS, Linux (Ubuntu/WSL2), and Windows.

---

## 🚀 Quick Start

### 1. Prerequisites

- **Git** (for cloning)
- **Python 3** (for Dotbot)
- **zsh** (preferred shell)
- **Bun** (for development hooks and package management)

### 2. Installation

```bash
git clone --recursive https://github.com/yourusername/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

### 3. Deploy Profiles

Deploy environment-specific configurations using the smart wrapper:

```bash
# macOS
./install-profile.sh mac

# Ubuntu / WSL 2
./install-profile.sh ubuntu
./install-profile.sh wsl

# Windows (PowerShell)
.\install-profile.ps1 windows
```

> **Pro Tip**: Use `./install-profile.sh --dry-run <profile>` to preview changes. Run `./bin/doctor.sh` to perform a full system health check.

---

## 🛡️ Security & Privacy

To keep your sensitive information (API keys, tokens, private emails) safe and out of version control, this repository supports local, untracked configuration files:

1. **`~/.zsh_secret`**: For sensitive tokens and API keys.
    - *Setup*: `cp config/zsh/common/.zsh_secret.example ~/.zsh_secret`
2. **`~/.localrc`**: For machine-specific environment overrides or private aliases.
3. **VSCode Local Settings**: Machine-specific VSCode settings (like font size) can be kept in the IDE without affecting the shared `settings.common.json`.

---

## 🏗️ Modular Architecture

This repository uses a **Fragmented Dotbot System** for maximum flexibility:

- **`meta/configs/`**: Standalone YAML fragments for individual tools (e.g., `nvim.yaml`, `zsh.yaml`).
- **`meta/configs/windows/`**: Windows-specific fragments.
- **`meta/profiles/`**: Environment definitions that list which fragments to apply.
- **`install-profile.sh`**: Dynamically merges `meta/base.yaml` with chosen fragments to perform a surgical installation.

---

## 🧰 Tech Stack

| Category | Tool | Description |
| :--- | :--- | :--- |
| **Shell** | [Zsh](https://www.zsh.org/) + [Antidote](https://getantidote.github.io/) | High-performance static plugin management with `zsh-defer` for zero-delay startup. |
| **Launcher** | [Raycast](https://www.raycast.com/) | Advanced launcher with script commands and deep integrations. |
| **Prompt** | [Oh My Posh](https://ohmyposh.dev/) | Cross-shell theme engine for consistent aesthetics. |
| **Editor** | [Neovim](https://neovim.io/) | Extensible editor with auto-syncing plugins & dependencies. |
| **Terminal** | [WezTerm](https://wezfurlong.org/wezterm/) | GPU-accelerated cross-platform terminal. |
| **Window Mgmt** | [Aerospace](https://github.com/nikitabobko/AeroSpace) + [Sketchybar](https://github.com/FelixKratz/SketchyBar) | (macOS) Tiling window management and custom status bar. |
| **File Manager** | [Yazi](https://yazi-rs.github.io/) + [xplr](https://xplr.art/) | Blazing fast Rust-based terminal file managers. |
| **Navigation** | [fzf](https://github.com/junegunn/fzf) + [zoxide](https://github.com/ajeetdsouza/zoxide) + [Atuin](https://github.com/atuinsh/atuin) | Fuzzy finder, smarter `cd`, and magical shell history. |
| **Multiplexer** | [tmux](https://github.com/tmux/tmux) + [Zellij](https://zellij.dev/) | Terminal multiplexing and workspaces. |
| **Modern CLI** | `eza`, `bat`, `delta`, `difftastic`, `dust` | Better versions of `ls`, `cat`, `diff`, and `du`. |
| **Dev Tooling** | `uv`, `volta`, `rustup`, `bun` | Toolchain management for Python, Node, Rust, and JS. |
| **System Info** | [fastfetch](https://github.com/fastfetch-cli/fastfetch) + [htop](https://htop.dev/) + [bottom](https://github.com/ClementTsang/bottom) | Pretty system info and modern system monitoring (btm). |

---

## 📂 Repository Structure

```text
.
├── config/              # Tool-specific configurations (source files)
├── meta/                # Dotbot fragments and platform profiles
├── setups/              # OS-level bootstrapping (macOS/Ubuntu)
├── Windows/             # Windows-specific installers and assets
├── bin/                 # Custom helper scripts
└── .lefthook/           # Git hooks (Linting, Commits)
```

---

## 🛠️ Development & Quality

- **Package Manager**: [Bun](https://bun.sh/) is used for all development tasks.
- **Git Hooks**: [Lefthook](https://github.com/evilmartians/lefthook) manages pre-commit checks.
- **Commits**: `bun run commit` for conventional commits.
- **Versioning**:
  - `bun run change`: Create a new changeset.
  - `bun run version`: Bump version and update `CHANGELOG.md`.

---

## 📜 License

MIT © yourname
