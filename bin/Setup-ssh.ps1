<#
.SYNOPSIS
Automates SSH key generation, initializes ~/.ssh/config on Windows 11,
starts ssh-agent, adds the key, and provides quick links.
#>

# Stop script execution on critical errors
$ErrorActionPreference = "Stop"

Write-Host "Enter your email or device identifier (e.g., user@example.com - Win11): " -ForegroundColor Cyan -NoNewline
$identifier = Read-Host

# Windows stores .ssh in the user's profile directory (C:\Users\Username\.ssh)
$sshDir = Join-Path $env:USERPROFILE ".ssh"
$keyPath = Join-Path $sshDir "id_ed25519"
$configPath = Join-Path $sshDir "config"

Write-Host "`n------------------------------------------------" -ForegroundColor Cyan
Write-Host "🚀 Starting SSH Setup for: $identifier" -ForegroundColor Cyan
Write-Host "------------------------------------------------" -ForegroundColor Cyan

# Step 1: Create .ssh directory if it doesn't exist
if (-not (Test-Path $sshDir)) {
    Write-Host "Creating .ssh directory..." -ForegroundColor Green
    New-Item -ItemType Directory -Path $sshDir | Out-Null
} else {
    Write-Host "Directory $sshDir already exists." -ForegroundColor Yellow
}

# Step 2: Generate SSH key if it doesn't already exist
if (Test-Path $keyPath) {
    Write-Host "WARNING: SSH key already exists at $keyPath." -ForegroundColor Yellow
    Write-Host "Skipping key generation to prevent overwriting your existing private key." -ForegroundColor Yellow
} else {
    Write-Host "Generating new ed25519 SSH key..." -ForegroundColor Green
    # Call the native Windows OpenSSH executable
    ssh-keygen -t ed25519 -C "$identifier" -f "$keyPath"
}

# Step 3: Initialize config file if it doesn't exist
if (-not (Test-Path $configPath)) {
    Write-Host "Initializing ~\config file..." -ForegroundColor Green
    $configContent = @"
# --- Default Settings for all hosts ---
Host *
    ServerAliveInterval 60
    AddKeysToAgent yes

# --- GitHub Configuration ---
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519
"@
    # Ensure it's saved without BOM for compatibility with SSH client
    $utf8NoBom = New-Object System.Text.UTF8Encoding $false
    [System.IO.File]::WriteAllText($configPath, $configContent, $utf8NoBom)
    Write-Host "Basic config file created." -ForegroundColor Green
} else {
    Write-Host "File $configPath already exists. Skipping initialization." -ForegroundColor Yellow
}

# Step 4: Start ssh-agent and add the key
Write-Host "Configuring and starting ssh-agent..." -ForegroundColor Green
try {
    # Check current status of the ssh-agent service
    $agentService = Get-Service -Name ssh-agent -ErrorAction Stop
    
    # Set service to start automatically if it isn't already
    if ($agentService.StartType -ne 'Automatic') {
        Set-Service -Name ssh-agent -StartupType Automatic
    }
    
    # Start the service if it's not running
    if ($agentService.Status -ne 'Running') {
        Start-Service -Name ssh-agent
    }
    
    Write-Host "ssh-agent is running. Adding the SSH key..." -ForegroundColor Green
    # Add the newly generated SSH private key to the ssh-agent
    ssh-add "$keyPath"
} catch {
    Write-Host "WARNING: Failed to configure ssh-agent. You may need to run PowerShell as Administrator." -ForegroundColor Yellow
    Write-Host "Error Details: $_" -ForegroundColor Red
}

# Step 5: Display Public Key and Links for the user
Write-Host "`n=================================================================" -ForegroundColor Green
Write-Host "✅ Setup Complete! Here is your PUBLIC KEY:" -ForegroundColor Green
Write-Host "-----------------------------------------------------------------" -ForegroundColor Cyan
Get-Content -Path "$keyPath.pub"
Write-Host "-----------------------------------------------------------------" -ForegroundColor Cyan
Write-Host "Next Step: Copy the text above and click the links below to add it:" -ForegroundColor Yellow
Write-Host ""
Write-Host "👉 GitHub: https://github.com/settings/keys" -ForegroundColor Cyan
Write-Host "👉 GitLab: https://gitlab.com/-/profile/keys" -ForegroundColor Cyan
Write-Host "=================================================================" -ForegroundColor Green