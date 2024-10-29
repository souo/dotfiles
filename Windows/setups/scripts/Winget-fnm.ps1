[CmdletBinding()]
param()

$ReadableName = "fnm"
$AppId = "Schniz.fnm"

$WingetParams = $null

. (Join-Path -Path "$PSScriptRoot\..\" -ChildPath "functions\Install-WingetApp.ps1")
Install-WingetApp $ReadableName $AppId $WingetParams
