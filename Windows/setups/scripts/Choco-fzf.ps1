[CmdletBinding()]
param()

$ReadableName = "fzf"
$ChocoPackage = "fzf"

$ChocoParams = $null

. (Join-Path -Path "$PSScriptRoot\..\" -ChildPath "functions\Install-ChocoApp.ps1")
Install-ChocoApp $ReadableName $ChocoPackage $ChocoParams
