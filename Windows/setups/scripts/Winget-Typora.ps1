[CmdletBinding()]
param()

$ReadableName = "Typora"
$AppId = "appmakes.Typora"

$WingetParams = $null

. (Join-Path -Path "$PSScriptRoot\..\" -ChildPath "functions\Install-WingetApp.ps1")
Install-WingetApp $ReadableName $AppId $WingetParams
