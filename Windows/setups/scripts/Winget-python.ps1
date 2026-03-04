[CmdletBinding()]
param()

. (Join-Path -Path "$PSScriptRoot\..\" -ChildPath "functions\Install-WingetApp.ps1")

#-----------------------------------------------
#                 SDK
#------------------------------------------------
$ReadableName = "Python 3.13"
$AppId = "Python.Python.3.13"
$WingetParams = $null

Install-WingetApp $ReadableName $AppId $WingetParams
