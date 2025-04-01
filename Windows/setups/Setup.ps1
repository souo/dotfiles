#Requires -Version 7


[CmdletBinding()]
param()


Write-Host "-------------------------------------------"
Write-Host "`n   Winget Apps `n" -ForegroundColor Magenta
Write-Host "-------------------------------------------"

& "$PSScriptRoot\scripts\Winget-1Password.ps1"
& "$PSScriptRoot\scripts\Winget-7zip.ps1"
& "$PSScriptRoot\scripts\Winget-Chocolatey.ps1"
& "$PSScriptRoot\scripts\Winget-dotnet.ps1"
& "$PSScriptRoot\scripts\Winget-python.ps1"
& "$PSScriptRoot\scripts\Winget-cmake.ps1"
& "$PSScriptRoot\scripts\Winget-DevHome.ps1"
& "$PSScriptRoot\scripts\Winget-PowerToys.ps1"
& "$PSScriptRoot\scripts\Winget-eza.ps1"
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
& "$PSScriptRoot\scripts\Winget-tokei.ps1"
& "$PSScriptRoot\scripts\Winget-flow.ps1"


Write-Host "-------------------------------------------"
Write-Host "`n  Choco Apps `n" -ForegroundColor Magenta
Write-Host "-------------------------------------------"


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
# & "$PSScriptRoot\scripts\Choco-zoxide.ps1"

#vars
$dotfilesPath = "$PSScriptRoot\..\.." | Convert-Path
# Set working directory
Set-Location $PSScriptRoot
[Environment]::CurrentDirectory = $PSScriptRoot

Write-Output $dotfilesPath


# Path Refresh
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")

Write-Host "-------------------------------------------"
Write-Host "`n   Install PS Modules `n" -ForegroundColor Magenta
Write-Host "-------------------------------------------"
$psModules = @(
    "CompletionPredictor"
    "PSScriptAnalyzer"
    "ps-color-scripts"
)

Import-Module $PSScriptRoot\functions\Show-Spinner.ps1 -force
# Install PS Modules
foreach ($psModule in $psModules) {
    if (!(Get-Module -ListAvailable -Name $psModule)) {
        Install-Module -Name $psModule -Force -AcceptLicense -Scope AllUsers &>$null 2>&1
        Write-Host "   [✔] $psModule    " -ForegroundColor green
    }
    else {
        Write-Host "   [✔] $psModule    " -ForegroundColor green
    }
}



Write-Host "------------------------------------------- "
Write-Host "`n  restore vscode extensions `n" -ForegroundColor Magenta
Write-Host "------------------------------------------- "

# VS Code extensions
& "$dotfilesPath\vscode\restore_extensions.ps1"

# Install bat themes
bat cache --clear
bat cache --build

# Start AltSnap on logon
& "$dotfilesPath\Windows\Altsnap\createTask.ps1" >$null
