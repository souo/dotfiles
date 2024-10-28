#Requires -RunAsAdministrator
#Requires -Version 7

# Winget & choco dependencies
$wingetDeps = @(
    "chocolatey.chocolatey"
    "eza-community.eza"
    "Schniz.fnm"
    "JetBrains.Toolbox"
    "ezwinports.make"
    "fastfetch-cli.fastfetch"
    "git.git"
    "github.cli"
    "kitware.cmake"
    "microsoft.powershell"
    "JanDeDobbeleer.OhMyPosh"
    "Microsoft.DevHome"
    "Microsoft.PowerToys"
    "Microsoft.VisualStudioCode"
    "7zip.7zip"
    "neovim.neovim"
    "appmakes.Typora"
    "antonreshetov.massCode"
    "Microsoft.VisualStudioCode"
    "AgileBits.1Password"
    "Logseq.Logseq"
    "2dust.v2rayN"
)

$chocoDeps = @(
    "altsnap"
    "bat"
    "fd"
    "fzf"
    "gawk"
    "lazygit"
    "mingw"
    "nerd-fonts-jetbrainsmono"
    "ripgrep"
    "wezterm"
    "zoxide"
)

$psModules = @(
    "CompletionPredictor"
    "PSScriptAnalyzer"
    "ps-color-scripts"
)

#vars
$dotfilesPath = "$PSScriptRoot\.." | Convert-Path
# Set working directory
Set-Location $PSScriptRoot
[Environment]::CurrentDirectory = $PSScriptRoot

Write-Output $dotfilesPath

Write-Host "Installing missing dependencies..."
$installedWingetDeps = winget list | Out-String

foreach ($wingetDep in $wingetDeps) {
    if ($installedWingetDeps -notmatch $wingetDep) {
        Write-Host "Installing $wingetDep"
        winget install --id $wingetDep
    }
}

# Path Refresh
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")

$installedChocoDeps = (choco list --limit-output --id-only).Split("`n")
foreach ($chocoDep in $chocoDeps) {
    if ($installedChocoDeps -notcontains $chocoDep) {
        choco install $chocoDep -y
    }
}

# Install PS Modules
foreach ($psModule in $psModules) {
    if (!(Get-Module -ListAvailable -Name $psModule)) {
        Install-Module -Name $psModule -Force -AcceptLicense -Scope CurrentUser
    }
}


function Backup-Item($FileName) {
    if (Test-Path $FileName) {
        Get-Item -Path "$FileName.bak" -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
        Rename-Item -Path $FileName -NewName "$FileName.bak" -Force
    }
}

$vs_code_home = "$env:APPDATA\Code\User"

$backups = @(
    "$vs_code_home\settings.json"
)

# Linked Files (Destination => Source)
$symlinks = @{
    “$HOME\Appdata\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" = "..\terminals\windowsterminal\settings.json"
    "$HOME\Documents\PowerShell\Profile.ps1"    = ".\PowerShell\Profile.ps1"
    "$HOME\.gitconfig"                          = "..\git\.gitconfig"
    "$HOME\.wslconfig"                          = ".\wsl\.wslconfig"
    "$HOME\.gitattributes"                      = "..\git\.gitattributes"
    "$HOME\.gitignore"                          = "..\git\.gitignore"
    "$HOME\AppData\Local\fastfetch"             = "..\fastfetch"
    "$HOME\AppData\Local\lazygit\config.yml"    = "..\lazygit\config.yml"
    "$HOME\AppData\Roaming\AltSnap\AltSnap.ini" = ".\AltSnap\AltSnap.ini"
    "$vs_code_home\settings.json"               = "..\vscode\settings.json"
    "$ENV:XDG_CONFIG_HOME\WezTerm"          = "..\terminals\wezterm\"
}

Write-Host "Backup items..."
foreach ($item in $backups) {
    Backup-Item $item
}

# Create Symbolic Links
Write-Host "Creating Symbolic Links..."
foreach ($symlink in $symlinks.GetEnumerator()) {
    Get-Item -Path $symlink.Key -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
    New-Item -ItemType SymbolicLink -Path $symlink.Key -Target (Resolve-Path $symlink.Value) -Force | Out-Null
}

# VS Code extensions
#powershell  "$dotfilesPath\vscode\vscode_restore_extensions.ps1"

# Install bat themes
bat cache --clear
bat cache --build

# Start AltSnap on logon
powershell "$dotfilesPath\Windows\Altsnap\createTask.ps1 >$null"
