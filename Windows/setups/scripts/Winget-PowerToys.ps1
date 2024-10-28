[CmdletBinding()]
param()

$ReadableName = "PowerToys"
$AppId = "Microsoft.PowerToys"

$WingetParams = $null

Import-Module $PSScriptRoot\..\functions\Install-WingetApp.ps1 -force
Install-WingetApp $ReadableName $AppId $WingetParams
