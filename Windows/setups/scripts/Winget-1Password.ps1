[CmdletBinding()]
param()

$ReadableName = "1Password"
$AppId = "AgileBits.1Password"

$WingetParams = $null

Import-Module $PSScriptRoot\..\functions\Install-WingetApp.ps1 -force
Install-WingetApp $ReadableName $AppId $WingetParams
