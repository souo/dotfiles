# Windows dotfiles
Windows-only files and config.
Work with PowerShell 7.x.

## Setup

1. check && change execution policy to allow execution unsigned local scripts
```
Get-ExecutionPolicy
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
```

2. install winget
```
./winget-install.ps1
```
3. run Setup as admin
```
.setups/Setup.ps1
```
