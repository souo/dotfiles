
function Invoke-SshCopyId {
    <#
    .SYNOPSIS
    Copy ssh public key to remote account

    .DESCRIPTION
    Copies public key to target machine
    Default is .ssh\id_ed25519.pub

 #>
    [CmdletBinding()]
    [alias("ssh-copy-id")]
    param(
        [Parameter(Position = 0, Mandatory = $True)]
        [string]$Target <# SSH compatible Name of Target machine #>,
        [Parameter( Position = 1, Mandatory = $False)]
        [string]$IdentityFile = "id_ed25519" <#Identity File, must be in .ssh directory #>,
        [switch]$Save = $False <# Save script used #>
    )

    $IdentityPath = Join-Path (Join-Path $env:USERPROFILE .ssh) $IdentityFile
    if (-not (Test-Path -Path $IdentityPath -PathType Leaf)) {
        Write-Host Key file $IdentityFile does not exist, use ssh-keygen
        exit(1)
    }
    $PUBLIC_KEY = get-content "${IdentityPath}.pub"
    $SCRIPT = @"
#!/bin/bash
#
PUBLIC_KEY="$PUBLIC_KEY"
umask 0077
[ -d ~/.ssh ]||mkdir -p ~/.ssh
[ -f ~/.ssh/authorized_keys ]|| touch ~/.ssh/authorized_keys
grep --quiet --fixed-strings "`$PUBLIC_KEY" ~/.ssh/authorized_keys
if [ `$? -ne 0 ]
    then
        echo "`$PUBLIC_KEY" >> ~/.ssh/authorized_keys
    else
       echo Key already exists, no update performed.
fi
"@

    if ($Save) {
        Set-Content .\ssh-copy-id.sh -Value $SCRIPT
    }

    # The sed step is to convert crlf to lf for bash - it's fussy
    $SCRIPT | ssh $Target -o StrictHostKeyChecking=no "sed 's/\r//' | bash"
    if ($?) {
        Write-Output "You should be able to login to $Target without a password using $IdentityFile key"
    }
    else {
        Write-Host "Could not connect to $Target - Terminating"  -ForegroundColor Red
    }

}
