[CmdletBinding()]
param()

$ReadableName = "JetBrains Toolbox"
$AppId = "JetBrains.Toolbox"

$WingetParams = $null

Import-Module $PSScriptRoot\..\functions\Install-WingetApp.ps1 -force
Install-WingetApp $ReadableName $AppId $WingetParams
