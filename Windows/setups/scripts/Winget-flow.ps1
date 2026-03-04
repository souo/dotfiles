[CmdletBinding()]
param()

. (Join-Path -Path "$PSScriptRoot\..\" -ChildPath "functions\Install-WingetApp.ps1")

#-----------------------------------------------
#                 SDK
#------------------------------------------------
$ReadableName = "Flow Launcher"
$AppId = "Flow-Launcher.Flow-Launcher"
$WingetParams = $null

Install-WingetApp $ReadableName $AppId $WingetParams
