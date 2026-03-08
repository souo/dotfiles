# dotfiles

## 2.0.0

### Major Changes

- Initial release of the new modular and optimized dotfiles architecture:

  - **Modular Dotbot**: Fragmented configuration logic for better cross-platform support.
  - **Enhanced Security**: Added `~/.zsh_secret` and `~/.localrc` support for private variables.
  - **Performance**: Switched to `antidote` for Zsh plugin management.
  - **Automation**: Updated `install-profile.sh` with dry-run support and better error handling.
  - **Engineering Quality**: Enabled `shellcheck` via Lefthook and standardized `README.md`.
