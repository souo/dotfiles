# Windows dotfiles

Windows-only files and config.
Work with PowerShell 7.x.

## Setup

1. check && change execution policy to allow execution unsigned local scripts

```
Get-ExecutionPolicy
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
```

2. run Setup as admin

```
.setups/Setup.ps1
```

3. install Scoop

```
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
```

4. python setup

```
scoop install pipx
pipx install uv
pipx install pre-commit
```

## Dev Home

see [https://learn.microsoft.com/zh-cn/windows/dev-drive/](https://learn.microsoft.com/zh-cn/windows/dev-drive/)

```
# npm
setx /M npm_config_cache C:\Users\2z\dev\Packages\npm

# nuget
setx /M NUGET_PACKAGES C:\Users\2z\dev\.nuget\packages

# upm
setx /M UPM_CACHE_ROOT  C:\Users\2z\dev\Packages\upm

# Pip cache (Python)
setx /M PIP_CACHE_DIR C:\Users\2z\dev\Packages\pip

# Cargo cache (Rust)
setx /M CARGO_HOME C:\Users\2z\dev\Packages\cargo
```
