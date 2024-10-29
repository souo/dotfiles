[CmdletBinding()]
param()


$ReadableName = "eza"
$AppId = "eza-community.eza"
$WingetParams = $null


. (Join-Path -Path "$PSScriptRoot\..\" -ChildPath "functions\Install-WingetApp.ps1")
Install-WingetApp $ReadableName $AppId $WingetParams
