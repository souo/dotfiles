[CmdletBinding()]
param()

$ReadableName = "DevHome"
$AppId = "Microsoft.DevHome"

$WingetParams = $null

Import-Module $PSScriptRoot\..\functions\Install-WingetApp.ps1 -force
Install-WingetApp $ReadableName $AppId $WingetParams
