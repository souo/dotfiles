[CmdletBinding()]
param()


$ReadableName =  "chocolatey"
$AppId =  "chocolatey.chocolatey"
$WingetParams = $null


. (Join-Path -Path "$PSScriptRoot\..\" -ChildPath "functions\Install-WingetApp.ps1")
Install-WingetApp $ReadableName $AppId $WingetParams
