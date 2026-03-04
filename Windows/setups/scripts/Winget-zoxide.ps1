[CmdletBinding()]
param()

$ReadableName = "zoxide"
$AppId = "ajeetdsouza.zoxide"

$WingetParams = $null

. (Join-Path -Path "$PSScriptRoot\..\" -ChildPath "functions\Install-WingetApp.ps1")
Install-WingetApp $ReadableName $AppId $WingetParams
