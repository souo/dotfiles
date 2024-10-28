[CmdletBinding()]
param()

$ReadableName = "tokei"
$AppId = "XAMPPRocky.Tokei"

$WingetParams = $null

Import-Module $PSScriptRoot\..\functions\Install-WingetApp.ps1 -force
Install-WingetApp $ReadableName $AppId $WingetParams
