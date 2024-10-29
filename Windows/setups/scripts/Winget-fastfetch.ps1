[CmdletBinding()]
param()

$ReadableName = "fastfetch"
$AppId = "fastfetch-cli.fastfetch"

$WingetParams = $null

. (Join-Path -Path "$PSScriptRoot\..\" -ChildPath "functions\Install-WingetApp.ps1")
Install-WingetApp $ReadableName $AppId $WingetParams
