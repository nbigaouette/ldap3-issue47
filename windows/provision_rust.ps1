# Inspired by https://codeblog.dotsandbrackets.com/vagrant-windows/

# Source common code from file
. $PSScriptRoot/provision_common.ps1

$setupFilename = "rustup-init.exe"
$rustupVersion = "1.21.1"
$sha256sum = "9f9e33fa4759075ec60e4da13798d1d66a4c2f43c5500e08714399313409dcf5"

# # Gnu toolchain, x86_64 build
# $hostTriple = "x86_64-pc-windows-gnu"
# MSVC toolchain, x86_64 build
# NOTE:
#       MSVC builds of rustup additionally require an installation of
#       Visual Studio 2019 or the Visual C++ Build Tools 2019. For
#       Visual Studio, make sure to check the "C++ tools" option. 
#       No additional software installation is necessary for basic
#       use of the GNU build.
#       https://visualstudio.microsoft.com/downloads/
$hostTriple = "x86_64-pc-windows-msvc"

# $downloadUrl = "https://static.rust-lang.org/rustup/dist/$hostTriple/$setupFilename"
# Permalink:
$downloadUrl = "https://dev-static.rust-lang.org/rustup/archive/$rustupVersion/$hostTriple/$setupFilename"

$setupFullPath = "$provisioningDirectory\$setupFilename"

$toolchainFile = Resolve-Path "$PSScriptRoot\..\rust-toolchain"

$toolchainVersion = Get-Content -Path $toolchainFile

# ----------------------------------------------------------------------
Write-Host "setupFilename:              $setupFilename"
Write-Host "sha256sum:                  $sha256sum"
Write-Host "downloadUrl:                $downloadUrl"
Write-Host "hostTriple:                 $hostTriple"
Write-Host "toolchainFile:              $toolchainFile"
Write-Host "toolchainVersion:           $toolchainVersion"
# ----------------------------------------------------------------------

DownloadFile -name "Rustup" -url $downloadUrl -downloadTo $setupFullPath

# Verify file integrity
SHA256Sum -setupFullPath $setupFullPath -sha256sum $sha256sum

if ($env:CI) {
    $rustupProfile = "minimal"
}
else {
    $rustupProfile = "default"
}

if (-not (Get-Command rustup 2> $null)) {
    # Install
    Write-Host "Running $setupFullPath..."
    RunCommand -command "$setupFullPath" -arguments @("--verbose", "-y", "--default-toolchain", "$toolchainVersion", "--default-host", "$hostTriple", "--profile=$rustupProfile")
}
else {
    Write-Host "Rustup already installed"
}

RefreshEnvironmentVariables

if ($env:CI) {
    Write-Host "Not changing CARGO_TARGET_DIR"
    if ($env:CARGO_TARGET_DIR) {
        Write-Host "CARGO_TARGET_DIR: $env:CARGO_TARGET_DIR"
    }
}
else {
    # Instruct cargo to place its build artifacts in a different default directory.
    # Without this, cargo will fail to compile a project that is shared between the host
    # and guest VM (in C:\vagrant) due to the directory being shared through some kind
    # of network mount. 
    Write-Host "Setting CARGO_TARGET_DIR to C:\cargo_target"
    RunCommand -command setx -arguments @("CARGO_TARGET_DIR", "C:\cargo_target")
}

RunCommand -command rustup -arguments @("--version")
RunCommand -command rustc -arguments @("--version")
RunCommand -command cargo -arguments @("--version")

if ($env:CI) {
    Write-Host "Not installing extra rustup components in CI"
}
else {
    RunCommand -command rustup -arguments @("component", "add", "clippy", "--toolchain", "$toolchainVersion-$hostTriple")
    RunCommand -command rustup -arguments @("component", "add", "rustfmt", "--toolchain", "$toolchainVersion-$hostTriple")
    RunCommand -command rustup -arguments @("component", "add", "rust-analysis", "--toolchain", "$toolchainVersion-$hostTriple")
    RunCommand -command rustup -arguments @("component", "add", "rls", "--toolchain", "$toolchainVersion-$hostTriple")
    RunCommand -command rustup -arguments @("component", "add", "llvm-tools-preview", "--toolchain", "$toolchainVersion-$hostTriple")
    # RunCommand -command rustup -arguments @("component", "add", "lldb-preview", "--toolchain", "$toolchainVersion-$hostTriple")
}