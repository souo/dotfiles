[CmdletBinding()]
param()

$ReadableName = "lua"
$AppId = "DEVCOM.Lua"

$WingetParams = $null

. (Join-Path -Path "$PSScriptRoot\..\" -ChildPath "functions\Install-WingetApp.ps1")
Install-WingetApp $ReadableName $AppId $WingetParams
