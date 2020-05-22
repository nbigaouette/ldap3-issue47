# ----------------------------------------------------------------------
function RunCommand {
    param([string]$command, [string]$arguments, [string]$working_dir)
    
    if (-not $PSBoundParameters.ContainsKey('working_dir')) {
        $working_dir = (Get-Location).Path
    }

    Write-Host "$command $arguments" -ForegroundColor Green

    $process = Start-Process $command -WorkingDirectory $working_dir -NoNewWindow -PassThru -Wait -ArgumentList $arguments

    if ($process.ExitCode -ne 0) {
        Write-Error "'$command $arguments' (in working directory '$working_dir') exited with status code $($process.ExitCode)" -ErrorAction Stop
    }
}

# ----------------------------------------------------------------------
function DownloadFile {
    param([string]$name, [string]$url, [string]$downloadTo)

    if (-not (Test-Path $downloadTo)) {
        Write-Host "Downloading $url..."
        Invoke-WebRequest -OutFile $downloadTo -Uri $url
    }
    else {
        Write-Host "$name already downloaded"
    }
}

# ----------------------------------------------------------------------
function SHA256Sum {
    param([string]$setupFullPath, [string]$sha256sum)

    # Verify file integrity
    $downloadedSha256sumObject = Get-FileHash -Path $setupFullPath -Algorithm SHA256
    $downloadedSha256sum = $downloadedSha256sumObject.Hash.ToLower()
    if ($downloadedSha256sum -eq $sha256sum) {
        Write-Host 'Downloaded file passed checksum validation' -ForegroundColor Green
    }
    else {
        throw "ERROR: $setupFullPath checksum failed! (got: $downloadedSha256sum should be: $sha256sum)"
    }
}

# ----------------------------------------------------------------------
function VerifyCodeSignature {
    param([string]$setupFullPath, [string]$signerCertificate)

    $codeSignature = Get-AuthenticodeSignature "$setupFullPath"
    Write-Host "Code signature: $codeSignature.Status" -ForegroundColor Green
    Write-Host $codeSignature.SignerCertificate -ForegroundColor Green
    if (($codeSignature.Status -eq "Valid") -and ($codeSignature.SignerCertificate.Thumbprint -eq "$signerCertificate")) {
        Write-Host 'Downloaded file has valid code signature' -ForegroundColor Green
    }
    else {
        throw "ERROR: $setupFullPath code signature is not valid! ($codeSignature)"
    }
}

# ----------------------------------------------------------------------
function RefreshEnvironmentVariables {
    # Update the script's PATH environment variable to find the installed binary
    # See https://stackoverflow.com/a/31845512
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")

    # Refresh environment variables
    refreshenv
}

# ----------------------------------------------------------------------
$provisioningDirectory = if ($env:PROVISIONING_DIRECTORY) {
    $env:PROVISIONING_DIRECTORY
}
else {
    # This _must_ match our `Vagrantfile`'s convention of uploaded files location
    "C:\provisioning"
}

# Make sure provisioning directory exists
New-Item -Path "$provisioningDirectory" -ItemType "directory" -Force | Out-Null
# Resolve the path, getting rid of relative paths or wildcards
$provisioningDirectory = Resolve-Path "$provisioningDirectory"

# Disable progress bars in CI environment. Prevent the following error:
#       Invoke-WebRequest : Win32 internal error "Access is denied" 0x5 occurred while reading
#       the console output buffer. 
if ($env:CI) {
    $progressPreference = 'silentlyContinue'
}

# Use newest TLS1.2 protocol version for HTTPS connections
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# ----------------------------------------------------------------------
Write-Host "provisioningDirectory:      $provisioningDirectory"
# ----------------------------------------------------------------------
