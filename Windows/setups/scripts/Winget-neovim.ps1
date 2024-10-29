[CmdletBinding()]
param()

$ReadableName = "neovim"
$AppId = "neovim.neovim"

$WingetParams = $null

. (Join-Path -Path "$PSScriptRoot\..\" -ChildPath "functions\Install-WingetApp.ps1")
Install-WingetApp $ReadableName $AppId $WingetParams
