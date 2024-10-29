[CmdletBinding()]
param()

$ReadableName = "cmake"
$AppId = "kitware.cmake"

$WingetParams = $null

. (Join-Path -Path "$PSScriptRoot\..\" -ChildPath "functions\Install-WingetApp.ps1")
Install-WingetApp $ReadableName $AppId $WingetParams
