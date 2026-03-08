[CmdletBinding()]
param(
    [Parameter(Mandatory, Position = 0)]
    [ValidateNotNullOrEmpty()]
    [string] $ProfileName
)

$ErrorActionPreference = "Stop"

$BASE_CONFIG = "base"
$CONFIG_SUFFIX = ".yaml"

$META_DIR = "meta"
$CONFIG_DIR = "configs/windows"
$PROFILES_DIR = "profiles"

$DOTBOT_DIR = "dotbot"
$DOTBOT_BIN = "bin/dotbot"
$BASEDIR = $PSScriptRoot

Set-Location $BASEDIR
git -C $DOTBOT_DIR submodule sync --quiet --recursive
git submodule update --init --recursive $DOTBOT_DIR

foreach ($PYTHON in ('python', 'python3', 'FAIL')) {
    # Python redirects to Microsoft Store in Windows 10 when not installed
    if (& { $ErrorActionPreference = "SilentlyContinue"
            ![string]::IsNullOrEmpty((&$PYTHON -V))
            $ErrorActionPreference = "Stop" }) {
        break
    }
}

if ($PYTHON -eq 'FAIL') {
    Write-Error "Error: Cannot find Python."
    return
}

$CONFIGS = @()

Get-Content ( Join-Path $BASEDIR  -ChildPath $META_DIR/$PROFILES_DIR/$ProfileName) | ForEach-Object {
    $CONFIGS += $_
}

$BaseConfigPath = Join-Path $BASEDIR  -ChildPath $META_DIR/$BASE_CONFIG$CONFIG_SUFFIX

try {
    # TempFileCollection manages  temp files and deletes them when it is disposed.
    $tempFiles = [System.CodeDom.Compiler.TempFileCollection]::new()
    foreach ($CONFIG in $CONFIGS) {
        Write-Output "`nConfigure $config"
        $file = New-TemporaryFile
        $tempFiles.AddFile($file.FullName, $false)
        Get-Content -Path $BaseConfigPath | Add-Content -Path $file
        Get-Content -Path ( Join-Path $BASEDIR  -ChildPath $META_DIR/$CONFIG_DIR/$CONFIG$CONFIG_SUFFIX ) | Add-Content -Path $file
        Write-Verbose (Get-Content -Path $file | Out-String)
        & $PYTHON $(Join-Path $BASEDIR -ChildPath $DOTBOT_DIR | Join-Path -ChildPath $DOTBOT_BIN) -d $BASEDIR -c $file
    }
}
finally {
    if ($null -ne $tempFiles) {
        $tempFiles.Dispose() #Deletes all temp files
    }
}

Write-Output "`n🔍 Checking for dead links in $HOME ..."
Get-ChildItem -Path $HOME -Depth 1 -Attributes ReparsePoint | ForEach-Object {
    $target = (Get-Item $_.FullName).Target
    if ($target -like "*$BASEDIR*" -and -not (Test-Path $target)) {
        Write-Warning "Found dead link: $($_.FullName) -> $target"
    }
}

Write-Output "`n✅ Finished deploying $ProfileName!"
