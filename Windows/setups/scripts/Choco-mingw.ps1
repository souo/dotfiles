<#
.NOTES
    MinGW: A native Windows port of the GNU Compiler Collection (GCC)
#>

[CmdletBinding()]
param()

$ReadableName = "mingw"
$ChocoPackage = "mingw"

$ChocoParams = $null

. (Join-Path -Path "$PSScriptRoot\..\" -ChildPath "functions\Install-ChocoApp.ps1")
Install-ChocoApp $ReadableName $ChocoPackage $ChocoParams
