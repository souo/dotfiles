[CmdletBinding()]
param()

$ReadableName = "OhMyPosh"
$AppId = "JanDeDobbeleer.OhMyPosh"

$WingetParams = $null

. (Join-Path -Path "$PSScriptRoot\..\" -ChildPath "functions\Install-WingetApp.ps1")
Install-WingetApp $ReadableName $AppId $WingetParams
