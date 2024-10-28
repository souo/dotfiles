[CmdletBinding()]
param()

$ReadableName = "git"
$AppId = "git.git"

$WingetParams = $null

Import-Module $PSScriptRoot\..\functions\Install-WingetApp.ps1 -force
Install-WingetApp $ReadableName $AppId $WingetParams
