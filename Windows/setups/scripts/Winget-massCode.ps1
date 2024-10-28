[CmdletBinding()]
param()

$ReadableName = "massCode"
$AppId = "antonreshetov.massCode"

$WingetParams = $null

Import-Module $PSScriptRoot\..\functions\Install-WingetApp.ps1 -force
Install-WingetApp $ReadableName $AppId $WingetParams
