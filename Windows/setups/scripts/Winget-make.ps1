[CmdletBinding()]
param()

$ReadableName = "make"
$AppId = "ezwinports.make"

$WingetParams = $null

Import-Module $PSScriptRoot\..\functions\Install-WingetApp.ps1 -force
Install-WingetApp $ReadableName $AppId $WingetParams
