[CmdletBinding()]
param()

$ReadableName = "fastfetch"
$AppId = "Fastfetch-cli.Fastfetch"

$WingetParams = $null

. (Join-Path -Path "$PSScriptRoot\..\" -ChildPath "functions\Install-WingetApp.ps1")
Install-WingetApp $ReadableName $AppId $WingetParams
