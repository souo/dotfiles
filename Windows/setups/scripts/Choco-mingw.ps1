[CmdletBinding()]
param()

$ReadableName = "mingw"
$ChocoPackage = "mingw"

$ChocoParams = $null

Import-Module $PSScriptRoot\..\functions\Install-ChocoApp.ps1 -force
Install-ChocoApp $ReadableName $ChocoPackage $ChocoParams
