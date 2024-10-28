[CmdletBinding()]
param()


$ReadableName =  "chocolatey"
$AppId =  "chocolatey.chocolatey"
$WingetParams = $null


Import-Module $PSScriptRoot\..\functions\Install-WingetApp.ps1 -force
Install-WingetApp $ReadableName $AppId $WingetParams
