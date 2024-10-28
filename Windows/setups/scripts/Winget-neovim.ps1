[CmdletBinding()]
param()

$ReadableName = "neovim"
$AppId = "neovim.neovim"

$WingetParams = $null

Import-Module $PSScriptRoot\..\functions\Install-WingetApp.ps1 -force
Install-WingetApp $ReadableName $AppId $WingetParams
