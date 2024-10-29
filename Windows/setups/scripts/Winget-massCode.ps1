[CmdletBinding()]
param()

$ReadableName = "massCode"
$AppId = "antonreshetov.massCode"

$WingetParams = $null

. (Join-Path -Path "$PSScriptRoot\..\" -ChildPath "functions\Install-WingetApp.ps1")
Install-WingetApp $ReadableName $AppId $WingetParams
