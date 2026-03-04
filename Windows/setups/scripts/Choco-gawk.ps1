[CmdletBinding()]
param()

$ReadableName = "gawk"
$ChocoPackage = "gawk"

$ChocoParams = $null

. (Join-Path -Path "$PSScriptRoot\..\" -ChildPath "functions\Install-ChocoApp.ps1")
Install-ChocoApp $ReadableName $ChocoPackage $ChocoParams
