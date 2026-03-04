[CmdletBinding()]
param()

$ReadableName = "ripgrep"
$ChocoPackage = "ripgrep"

$ChocoParams = $null

. (Join-Path -Path "$PSScriptRoot\..\" -ChildPath "functions\Install-ChocoApp.ps1")
Install-ChocoApp $ReadableName $ChocoPackage $ChocoParams
