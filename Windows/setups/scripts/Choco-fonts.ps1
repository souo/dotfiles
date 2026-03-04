[CmdletBinding()]
param()

$ReadableName = "Jetbrainsmono Nerd Font"
$ChocoPackage = "nerd-fonts-jetbrainsmono"

$ChocoParams = $null

. (Join-Path -Path "$PSScriptRoot\..\" -ChildPath "functions\Install-ChocoApp.ps1")
Install-ChocoApp $ReadableName $ChocoPackage $ChocoParams
