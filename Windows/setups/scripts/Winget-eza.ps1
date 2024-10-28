[CmdletBinding()]
param()


$ReadableName = "eza"
$AppId = "eza-community.eza"
$WingetParams = $null


Import-Module $PSScriptRoot\..\functions\Install-WingetApp.ps1 -force
Install-WingetApp $ReadableName $AppId $WingetParams
