[CmdletBinding()]
param()

. (Join-Path -Path "$PSScriptRoot\..\" -ChildPath "functions\Install-WingetApp.ps1")

Install-WingetApp "tokei" "XAMPPRocky.Tokei"
Install-WingetApp "ripgrep" "BurntSushi.ripgrep.MSVC"
