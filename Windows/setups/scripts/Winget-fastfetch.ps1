[CmdletBinding()]
param()

$ReadableName = "fastfetch"
$AppId = "fastfetch-cli.fastfetch"

$WingetParams = $null

Import-Module $PSScriptRoot\..\functions\Install-WingetApp.ps1 -force
Install-WingetApp $ReadableName $AppId $WingetParams
