[CmdletBinding()]
param()

$ReadableName = "fzf"
$ChocoPackage = "fzf"

$ChocoParams = $null

Import-Module $PSScriptRoot\..\functions\Install-ChocoApp.ps1 -force
Install-ChocoApp $ReadableName $ChocoPackage $ChocoParams
