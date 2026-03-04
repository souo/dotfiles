[CmdletBinding()]
param()


$ReadableName = "7zip"
$AppId = "7zip.7zip"
$WingetParams = $null

. (Join-Path -Path "$PSScriptRoot\..\" -ChildPath "functions\Install-WingetApp.ps1")
Install-WingetApp $ReadableName $AppId $WingetParams
