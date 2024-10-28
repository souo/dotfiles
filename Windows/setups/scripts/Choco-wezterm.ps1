[CmdletBinding()]
param()

$ReadableName = "wezterm"
$ChocoPackage = "wezterm"

$ChocoParams = $null

Import-Module $PSScriptRoot\..\functions\Install-ChocoApp.ps1 -force
Install-ChocoApp $ReadableName $ChocoPackage $ChocoParams
