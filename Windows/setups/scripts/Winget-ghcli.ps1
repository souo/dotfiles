[CmdletBinding()]
param()

$ReadableName = "Github cli"
$AppId = "github.cli"

$WingetParams = $null

Import-Module $PSScriptRoot\..\functions\Install-WingetApp.ps1 -force
Install-WingetApp $ReadableName $AppId $WingetParams
