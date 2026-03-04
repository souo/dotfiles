[CmdletBinding()]
param()

$ReadableName = "JetBrains Toolbox"
$AppId = "JetBrains.Toolbox"

$WingetParams = $null

. (Join-Path -Path "$PSScriptRoot\..\" -ChildPath "functions\Install-WingetApp.ps1")
Install-WingetApp $ReadableName $AppId $WingetParams
