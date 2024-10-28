[CmdletBinding()]
param()

$ReadableName = "Typora"
$AppId = "appmakes.Typora"

$WingetParams = $null

Import-Module $PSScriptRoot\..\functions\Install-WingetApp.ps1 -force
Install-WingetApp $ReadableName $AppId $WingetParams
