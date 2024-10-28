[CmdletBinding()]
param()

$ReadableName = "fnm"
$AppId = "Schniz.fnm"

$WingetParams = $null

Import-Module $PSScriptRoot\..\functions\Install-WingetApp.ps1 -force
Install-WingetApp $ReadableName $AppId $WingetParams
