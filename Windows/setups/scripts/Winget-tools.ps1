[CmdletBinding()]
param()

. (Join-Path -Path "$PSScriptRoot\..\" -ChildPath "functions\Install-WingetApp.ps1")

Install-WingetApp "FFmpeg" "Gyan.FFmpeg"
Install-WingetApp "ImageMagic" "ImageMagick.ImageMagickg"
