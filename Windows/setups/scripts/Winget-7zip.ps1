[CmdletBinding()]
param()


$ReadableName = "7zip"
$AppId = "7zip.7zip"
$WingetParams = $null

Import-Module $PSScriptRoot\..\functions\Install-WingetApp.ps1 -force
Install-WingetApp $ReadableName $AppId $WingetParams
