[CmdletBinding()]
param()

$ReadableName = "Github cli"
$AppId = "GitHub.cli"

$WingetParams = $null

. (Join-Path -Path "$PSScriptRoot\..\" -ChildPath "functions\Install-WingetApp.ps1")
Install-WingetApp $ReadableName $AppId $WingetParams
