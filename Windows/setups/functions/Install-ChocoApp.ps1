. $PSScriptRoot\Show-Spinner.ps1
. $PSScriptRoot\Confirm-IsAdmin.ps1

function Install-ChocoApp {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string] $ReadableName,

        [Parameter(Mandatory, Position = 1)]
        [ValidateNotNullOrEmpty()]
        [string] $ChocoPackage,

        [Parameter(Position = 2)]
        [string] $ChocoParams

    )

    begin {
        Write-Verbose "Starting $($MyInvocation.MyCommand)"
    }

    process {
        if (-not (Confirm-IsAdmin)){
            Write-Error "Chocolatey needs to be run as an administrator for this action to work."
            exit 1
        }

        if (Confirm-Install($ChocoPackage)) {
            Write-Verbose  "$ChocoPackage already Installed"
            Write-Host "   [✔] $ReadableName    " -ForegroundColor green
            Return
        }

        # region Installer
        # Default Parameter
        $InstallerParams = 'ALLUSERS=1'
        if ($ChocoParams) {
            $InstallerParams = ($InstallerParams + ' ' + $ChocoParams)
            $ChocoParams = $null
        }

        $chocoArgs =  "$ChocoPackage --acceptlicense --limitoutput --no-progress --yes --params `"`'$InstallerParams`'`""
        $sb = [scriptblock]::Create("choco install $chocoArgs")
        try {
            Show-Spinner $sb -msg $ReadableName -color green >$null 2>&1
            #Check if install is ok
            $IsInstalled = Confirm-Install $ChocoPackage

            if ($IsInstalled) {
                 Write-Host "   [✔] $ReadableName    " -ForegroundColor green
            }
            else {
                Write-Host "   [✖] $ReadableName    " -ForegroundColor red
            }

        }
        catch {
            Write-Host "   [✖] $ReadableName    " -ForegroundColor red
        }
        #endregion Installer

    }

    end {
        Write-Verbose "Ending: $($MyInvocation.MyCommand)"
    }
}


#Check if app is installed
function Confirm-Install ($ChocoPackage) {
    #Get "Winget List AppID"
    $InstalledApp = & "choco" list -r --id-only -e $ChocoPackage | Out-String

    #Return if AppID exists in the list
    if ($InstalledApp -match [regex]::Escape($ChocoPackage)) {
        return $true
    }
    else {
        return $false
    }
}
