[CmdletBinding()]
param()

$ReadableName = "PowerToys"
$AppId = "Microsoft.PowerToys"

$WingetParams = $null

. (Join-Path -Path "$PSScriptRoot\..\" -ChildPath "functions\Install-WingetApp.ps1")
Install-WingetApp $ReadableName $AppId $WingetParams
