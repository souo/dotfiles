[CmdletBinding()]
param()

$ReadableName = "1Password"
$AppId = "AgileBits.1Password"

$WingetParams = $null

. (Join-Path -Path "$PSScriptRoot\..\" -ChildPath "functions\Install-WingetApp.ps1")
Install-WingetApp $ReadableName $AppId $WingetParams
