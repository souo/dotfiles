[CmdletBinding()]
param()

$ReadableName = "VisualStudioCode"
$AppId = "Microsoft.VisualStudioCode"

$WingetParams = $null

Import-Module $PSScriptRoot\..\functions\Install-WingetApp.ps1 -force
Install-WingetApp $ReadableName $AppId $WingetParams
