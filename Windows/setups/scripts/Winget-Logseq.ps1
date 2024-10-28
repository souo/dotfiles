[CmdletBinding()]
param()

$ReadableName = "Logseq"
$AppId = "Logseq.Logseq"

$WingetParams = $null

Import-Module $PSScriptRoot\..\functions\Install-WingetApp.ps1 -force
Install-WingetApp $ReadableName $AppId $WingetParams
