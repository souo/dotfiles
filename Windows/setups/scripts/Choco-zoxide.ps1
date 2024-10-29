[CmdletBinding()]
param()

$ReadableName = "zoxide"
$ChocoPackage = "zoxide"

$ChocoParams = $null

. (Join-Path -Path "$PSScriptRoot\..\" -ChildPath "functions\Install-ChocoApp.ps1")
Install-ChocoApp $ReadableName $ChocoPackage $ChocoParams
