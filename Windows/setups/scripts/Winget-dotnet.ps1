[CmdletBinding()]
param()

. (Join-Path -Path "$PSScriptRoot\..\" -ChildPath "functions\Install-WingetApp.ps1")

#-----------------------------------------------
#                 SDK
#------------------------------------------------
$ReadableName = "DOTNET SDK 8"
$AppId = "Microsoft.DotNet.SDK.8"
$WingetParams = $null

Install-WingetApp $ReadableName $AppId $WingetParams
