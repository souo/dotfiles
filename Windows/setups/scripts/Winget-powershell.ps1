[CmdletBinding()]
param()

$ReadableName = "powershell"
$AppId = "microsoft.powershell"

$WingetParams = $null

Import-Module $PSScriptRoot\..\functions\Install-WingetApp.ps1 -force
Install-WingetApp $ReadableName $AppId $WingetParams
