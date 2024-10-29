[CmdletBinding()]
param()

$ReadableName = "DevHome"
$AppId = "Microsoft.DevHome"

$WingetParams = $null

. (Join-Path -Path "$PSScriptRoot\..\" -ChildPath "functions\Install-WingetApp.ps1")
Install-WingetApp $ReadableName $AppId $WingetParams
