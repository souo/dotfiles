[CmdletBinding()]
param()


$ReadableName =  "chocolatey"
$AppId =  "Chocolatey.Chocolatey"
$WingetParams = $null


. (Join-Path -Path "$PSScriptRoot\..\" -ChildPath "functions\Install-WingetApp.ps1")
Install-WingetApp $ReadableName $AppId $WingetParams
