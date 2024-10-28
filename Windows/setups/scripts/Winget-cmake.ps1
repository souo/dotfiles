[CmdletBinding()]
param()

$ReadableName = "cmake"
$AppId = "kitware.cmake"

$WingetParams = $null

Import-Module $PSScriptRoot\..\functions\Install-WingetApp.ps1 -force
Install-WingetApp $ReadableName $AppId $WingetParams
