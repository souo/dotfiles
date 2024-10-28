#Requires -RunAsAdministrator
#Requires -Version 7


[CmdletBinding()]
param()


Write-Host "------------------------- "
Write-Host "`n   Winget Apps `n" -ForegroundColor Magenta
Write-Host "------------------------- "

& "$PSScriptRoot\scripts\Winget-1Password.ps1"
& "$PSScriptRoot\scripts\Winget-7zip.ps1"
& "$PSScriptRoot\scripts\Winget-Chocolatey.ps1"
& "$PSScriptRoot\scripts\Winget-cmake.ps1"
& "$PSScriptRoot\scripts\Winget-DevHome.ps1"
& "$PSScriptRoot\scripts\Winget-eza.ps1"
& "$PSScriptRoot\scripts\Winget-fnm.ps1"
& "$PSScriptRoot\scripts\Winget-ghcli.ps1"
& "$PSScriptRoot\scripts\Winget-git.ps1"
& "$PSScriptRoot\scripts\Winget-JBToolbox.ps1"
& "$PSScriptRoot\scripts\Winget-Logseq.ps1"
& "$PSScriptRoot\scripts\Winget-make.ps1"
& "$PSScriptRoot\scripts\Winget-massCode.ps1"
& "$PSScriptRoot\scripts\Winget-OhMyPosh.ps1"
& "$PSScriptRoot\scripts\Winget-fastfetch.ps1"
& "$PSScriptRoot\scripts\Winget-neovim.ps1"
& "$PSScriptRoot\scripts\Winget-Typora.ps1"
& "$PSScriptRoot\scripts\Winget-VisualStudioCode.ps1"



Write-Host "------------------------- "
Write-Host "`n  Choco Apps `n" -ForegroundColor Magenta
Write-Host "------------------------- "


& "$PSScriptRoot\scripts\Choco-altsnap.ps1"
& "$PSScriptRoot\scripts\Choco-bat.ps1"
& "$PSScriptRoot\scripts\Choco-fd.ps1"
& "$PSScriptRoot\scripts\Choco-fonts.ps1"
& "$PSScriptRoot\scripts\Choco-fzf.ps1"
& "$PSScriptRoot\scripts\Choco-gawk.ps1"
& "$PSScriptRoot\scripts\Choco-lazygit.ps1"
& "$PSScriptRoot\scripts\Choco-mingw.ps1"
& "$PSScriptRoot\scripts\Choco-ripgrep.ps1"
& "$PSScriptRoot\scripts\Choco-wezterm.ps1"
& "$PSScriptRoot\scripts\Choco-zoxide.ps1"
& "$PSScriptRoot\scripts\Choco-tokei.ps1"
