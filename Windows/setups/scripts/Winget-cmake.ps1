[CmdletBinding()]
param()

$ReadableName = "cmake"
$AppId = "Kitware.CMake"

$WingetParams = $null

. (Join-Path -Path "$PSScriptRoot\..\" -ChildPath "functions\Install-WingetApp.ps1")
Install-WingetApp $ReadableName $AppId $WingetParams
