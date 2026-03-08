FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

# --- System Dependencies ---
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    zsh \
    python3-pip \
    python3-venv \
    fzf \
    zoxide \
    ripgrep \
    bat \
    eza \
    neovim \
    tmux \
    build-essential \
    curl \
    git \
    sudo \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# --- Bun (JS Runtime) ---
RUN curl -fsSL https://bun.sh/install | bash

# --- UV (Python Package Manager) ---
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# --- Set default shell to ZSH for the user ---
USER vscode
RUN sudo chsh -s $(which zsh) vscode

ENV SHELL=/bin/zsh
WORKDIR /workspaces/dotfiles
