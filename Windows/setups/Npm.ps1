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

        if (Confirm-AppInstall($AppName)) {
            Write-Verbose  "$AppName already Installed"
            Write-Host "   [✔] $ReadableName" -ForegroundColor green
            Return
        }
        $sb = [scriptblock]::Create("npm install -g $AppName")
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
    $appVersion = npm list -g $AppName --depth=0 2>$null | Select-String -Pattern $AppName

    if ($appVersion) {
        Write-Verbose "$AppName is already installed. Version: $($appVersion -replace '^.*@(.*)', '$1')"
        return $true
    }
    else {
        Write-Verbose "$AppName  is not installed."
        return $false
    }
}

# Function to check if npm is installed
function Confirm-NpmInstall() {
    $npmVersion = npm -v 2>$null
    if ($npmVersion) {
        Write-Verbose "npm is installed. Version: $npmVersion"
        return $true
    }
    else {
        Write-Verbose "npm is not installed. Please install Node.js and npm first."
        return $false
    }
}


# Define the list of apps to be installed
$apps = @("openupm-cli")


# Main script
if (Confirm-NpmInstall) {
    foreach ($app in $apps) {
        Install-App  $app  $app
    }
}
