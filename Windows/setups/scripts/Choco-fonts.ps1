[CmdletBinding()]
param()

$ReadableName = "Jetbrainsmono Nerd Font"
$ChocoPackage = "nerd-fonts-jetbrainsmono"

$ChocoParams = $null

Import-Module $PSScriptRoot\..\functions\Install-ChocoApp.ps1 -force
Install-ChocoApp $ReadableName $ChocoPackage $ChocoParams
