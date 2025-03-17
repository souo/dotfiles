[CmdletBinding()]
param()

. (Join-Path -Path "$PSScriptRoot\..\" -ChildPath "functions\Install-WingetApp.ps1")

#-----------------------------------------------
#                 SDK
#------------------------------------------------
$ReadableName = "Python 3.12"
$AppId = "Python.Python.3.12"
$WingetParams = $null

Install-WingetApp $ReadableName $AppId $WingetParams
