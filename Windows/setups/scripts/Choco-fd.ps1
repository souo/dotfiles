[CmdletBinding()]
param()

$ReadableName = "fd"
$ChocoPackage = "fd"

$ChocoParams = $null

. (Join-Path -Path "$PSScriptRoot\..\" -ChildPath "functions\Install-ChocoApp.ps1")
Install-ChocoApp $ReadableName $ChocoPackage $ChocoParams
