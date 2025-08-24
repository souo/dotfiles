[CmdletBinding()]
param()

. (Join-Path -Path "$PSScriptRoot\..\" -ChildPath "functions\Install-WingetApp.ps1")

#-----------------------------------------------
#                 SDK
#------------------------------------------------
$ReadableName = "volta"
$AppId = " Volta.Volta"
$WingetParams = $null

Install-WingetApp $ReadableName $AppId $WingetParams
