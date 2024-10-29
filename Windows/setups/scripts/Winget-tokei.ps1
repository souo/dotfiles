[CmdletBinding()]
param()

$ReadableName = "tokei"
$AppId = "XAMPPRocky.Tokei"

$WingetParams = $null

. (Join-Path -Path "$PSScriptRoot\..\" -ChildPath "functions\Install-WingetApp.ps1")
Install-WingetApp $ReadableName $AppId $WingetParams
