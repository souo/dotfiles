[CmdletBinding()]
param()

$ReadableName = "neovim"
$AppId = "Neovim.Neovim"

$WingetParams = $null

. (Join-Path -Path "$PSScriptRoot\..\" -ChildPath "functions\Install-WingetApp.ps1")
Install-WingetApp $ReadableName $AppId $WingetParams
