[CmdletBinding()]
param()


. $PSScriptRoot\functions\Show-Spinner.ps1
function Install-App {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string] $ReadableName,

        [Parameter(Mandatory, Position = 1)]
        [ValidateNotNullOrEmpty()]
        [string] $AppName

    )

    begin {
        Write-Verbose "Starting $($MyInvocation.MyCommand)"
    }

    process {

        if (Confirm-AppInstall $AppName) {
            Write-Verbose  "$AppName already Installed"
            Write-Host "   [✔] $ReadableName" -ForegroundColor green
            Return
        }
        $sb = [scriptblock]::Create("pipx  install $AppName")
        try {
            Show-Spinner $sb -msg $ReadableName -color green >$null 2>&1

            #Check if install is ok
            $IsInstalled = Confirm-AppInstall $AppName

            if ($IsInstalled) {
                Write-Host "   [✔] $ReadableName  " -ForegroundColor green
            }
            else {
                Write-Host "   [✖] $ReadableName  " -ForegroundColor red
            }
        }
        catch {
            $_ | Out-String
            Write-Host "   [✖] $ReadableName  " -ForegroundColor red
        }
        #endregion Installer

    }

    end {
        Write-Verbose "Ending: $($MyInvocation.MyCommand)"
    }
}


#Check if app is installed
function Confirm-AppInstall ($AppName) {
    # Check if the app is installed
    $AppInstalled = pipx list | Select-String -Pattern $AppName

    if ($AppInstalled ) {
        Write-Verbose "$AppName is already installed"
        return $true
    }
    else {
        Write-Verbose "$AppName  is not installed."
        return $false
    }
}


# Function to check if a command exists
function CommandExists {
    param (
        [string]$command
    )
    $null -ne (Get-Command $command -ErrorAction SilentlyContinue)
}


# Define the list of apps to be installed
$apps = @("pre-commit", "uv")


# Check if pipx is installed
if (-not (CommandExists -command "pipx")) {
    Write-Output "pipx is not installed. Installing pipx..."
    python -m pip install --user pipx
    python -m pipx ensurepath
    # Reload profile to ensure pipx is available in the current session
    & $PROFILE
}

# Install apps using pipx if they are not already installed
foreach ($app in $apps) {
    Install-App  $app  $app
}
