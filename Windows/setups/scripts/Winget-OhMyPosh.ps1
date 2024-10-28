[CmdletBinding()]
param()

$ReadableName = "OhMyPosh"
$AppId = "JanDeDobbeleer.OhMyPosh"

$WingetParams = $null

Import-Module $PSScriptRoot\..\functions\Install-WingetApp.ps1 -force
Install-WingetApp $ReadableName $AppId $WingetParams
