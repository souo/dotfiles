# dotfiles

My dotfile, managed with dotbot.

## Supported platforms

My daily drivers currently are `wezterm + zsh + tmux` on:

-   Ubuntu 24.04 WSL 2 on Windows 11
-   Ubuntu 24.04
-   macOS

| **Module Type**    |                                       **Module Name**                                        |
| :----------------- | :------------------------------------------------------------------------------------------: |
| Shell              |                       [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh)                        |
| Promt Theme Engine |                  [oh-my-posh](https://github.com/JanDeDobbeleer/oh-my-posh)                  |
| System Info Tool   |   [fastfetch](https://github.com/fastfetch-cli/fastfetch) </br> [htop](https://htop.dev/)    |
| Terminal           |                        [wezterm](https://github.com/wezterm/wezterm)                         |
| File Manager       | [yazi](https://github.com/sxyazi/yazi) </br> [thunar](https://github.com/xfce-mirror/thunar) |
| Text Editor        |                           [nvim](https://github.com/neovim/neovim)                           |
| Icon Theme         |      [papirus-icon-theme](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme)      |
| Cursor Theme       |                     [Simp1e Cursors](https://gitlab.com/cursors/simp1e)                      |
| Font               |                                 **JetBrainsMono Nerd Font**                                  |

## Install

### Setup

-   Mac and Ubuntu: `./setups/setup.sh`
-   Windows: `.\Windows\setups\Setup.ps1`

### Install dotfiles

Use [dotbot](https://github.com/anishathalye/dotbot) to generate symbolic links. See [install.conf.yaml](./install.conf.yaml).

```
# mac
./install mac
#  ubuntu
./install ubuntu
# wsl
./install wsl
# win
.install.ps1 all
```
