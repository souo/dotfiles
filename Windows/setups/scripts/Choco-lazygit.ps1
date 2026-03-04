[CmdletBinding()]
param()

$ReadableName = "lazygit"
$ChocoPackage = "lazygit"

$ChocoParams = $null

. (Join-Path -Path "$PSScriptRoot\..\" -ChildPath "functions\Install-ChocoApp.ps1")
Install-ChocoApp $ReadableName $ChocoPackage $ChocoParams
