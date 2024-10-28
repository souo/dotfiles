[CmdletBinding()]
param()

$ReadableName = "zoxide"
$ChocoPackage = "zoxide"

$ChocoParams = $null

Import-Module $PSScriptRoot\..\functions\Install-ChocoApp.ps1 -force
Install-ChocoApp $ReadableName $ChocoPackage $ChocoParams
