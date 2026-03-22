[CmdletBinding()]
param(
    [Parameter(Mandatory, Position = 0)]
    [ValidateNotNullOrEmpty()]
    [string] $ProfileName,

    [Parameter()]
    [switch] $DryRun
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

Write-Host "🚀 Initializing submodules..." -ForegroundColor Cyan
git -C $DOTBOT_DIR submodule sync --quiet --recursive
git submodule update --init --recursive $DOTBOT_DIR

# --- Find Python ---
foreach ($PYTHON in ('python', 'python3', 'FAIL')) {
    if (& { $ErrorActionPreference = "SilentlyContinue"; ![string]::IsNullOrEmpty((&$PYTHON -V)); $ErrorActionPreference = "Stop" }) { break }
}
if ($PYTHON -eq 'FAIL') { Write-Error "Error: Cannot find Python."; return }

# --- Read Profile ---
$ProfileFile = Join-Path $BASEDIR "$META_DIR/$PROFILES_DIR/$ProfileName"
if (-not (Test-Path $ProfileFile)) { Write-Error "Profile $ProfileName not found."; return }
$Configs = Get-Content $ProfileFile | Where-Object { $_ -notmatch '^\s*(#|$)' }

# --- Prepare Combined Config ---
Write-Host "📦 Preparing unified configuration for profile: $ProfileName..." -ForegroundColor Cyan
$TempConfigFile = [IO.Path]::GetTempFileName()

try {
    $BaseConfigPath = Join-Path $BASEDIR "$META_DIR/$BASE_CONFIG$CONFIG_SUFFIX"
    Get-Content $BaseConfigPath | Set-Content $TempConfigFile

    $ValidCount = 0
    foreach ($Config in $Configs) {
        $ConfigPath = Join-Path $BASEDIR "$META_DIR/$CONFIG_DIR/$Config$CONFIG_SUFFIX"
        if (Test-Path $ConfigPath) {
            Add-Content $TempConfigFile "`n# --- Fragment: $Config ---"
            Get-Content $ConfigPath | Add-Content $TempConfigFile
            $ValidCount++
        } else {
            Write-Warning "Configuration $Config not found at $ConfigPath. Skipping."
        }
    }

    if ($ValidCount -eq 0) { Write-Error "No valid configuration fragments found."; return }

    Write-Host "✨ Deploying $ValidCount fragments via Dotbot..." -ForegroundColor Green

    # --- Run Dotbot ONCE ---
    $DotbotPath = Join-Path $BASEDIR "$DOTBOT_DIR/$DOTBOT_BIN"
    $Args = @("-d", $BASEDIR, "-c", $TempConfigFile)
    if ($DryRun) { $Args += "--dry-run" }

    & $PYTHON $DotbotPath $Args
}
finally {
    if (Test-Path $TempConfigFile) { Remove-Item $TempConfigFile -Force }
}

# --- Dead Link Check ---
Write-Host "`n🔍 Checking for dead links in $HOME ..." -ForegroundColor Yellow
Get-ChildItem -Path $HOME -Depth 1 -Attributes ReparsePoint | ForEach-Object {
    $target = (Get-Item $_.FullName).Target
    if ($target -like "*$BASEDIR*" -and -not (Test-Path $target)) {
        Write-Warning "Found dead link: $($_.FullName) -> $target"
    }
}

Write-Host "`n✅ Finished deploying $ProfileName!" -ForegroundColor Green
