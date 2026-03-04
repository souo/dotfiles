[CmdletBinding()]
param()

$ReadableName = "powershell"
$AppId = "microsoft.powershell"

$WingetParams = $null

. (Join-Path -Path "$PSScriptRoot\..\" -ChildPath "functions\Install-WingetApp.ps1")
Install-WingetApp $ReadableName $AppId $WingetParams
