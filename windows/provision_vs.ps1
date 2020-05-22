# Source common code from file
. $PSScriptRoot/provision_common.ps1

$setupFilename = "vs_buildtools.exe"
$downloadUrl = "https://aka.ms/vs/16/release/$setupFilename"
$userAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML like Gecko) Chrome/51.0.2704.79 Safari/537.36 Edge/14.14931"
$setupFullPath = "$provisioningDirectory\$setupFilename"
$microsoftSignerCertificate = "711AF71DC4C4952C8ED65BB4BA06826ED3922A32"

# ----------------------------------------------------------------------
Write-Host "setupFilename:              $setupFilename"
Write-Host "downloadUrl:                $downloadUrl"
Write-Host "userAgent:                  $userAgent"
Write-Host "setupFullPath:              $setupFullPath"
Write-Host "microsoftSignerCertificate: $microsoftSignerCertificate"
# ----------------------------------------------------------------------

DownloadFile -name "Visual C++ Build Tools" -url $downloadUrl -downloadTo $setupFullPath

# Verify file integrity
# Use code signature instead of checksum because the binary changes everyday
# VerifyCodeSignature -setupFullPath $setupFullPath -signerCertificate $microsoftSignerCertificate

# Documentation for:
#   svs_builttools.exe's command line arguments
#       https://docs.microsoft.com/en-us/visualstudio/install/use-command-line-parameters-to-install-visual-studio?view=vs-2019
#   How to export a setup config file:
#       https://docs.microsoft.com/en-us/visualstudio/install/import-export-installation-configurations?view=vs-2019
#       To obtain the list of components to install, use the 'export' functionality described above,
#       select the packages you want to install and inspect the generated file.
#   Full list of available components:
#       https://docs.microsoft.com/en-us/visualstudio/install/workload-component-id-vs-build-tools?view=vs-2019#c-build-tools

Write-Host "Running $setupFullPath..."
RunCommand -command "$setupFullPath" -arguments @(
    "--quiet",
    "--add", "Microsoft.VisualStudio.Workload.VCTools",
    "--add", "Microsoft.VisualStudio.Component.Roslyn.Compiler",
    "--add", "Microsoft.Component.MSBuild",
    "--add", "Microsoft.VisualStudio.Component.CoreBuildTools",
    "--add", "Microsoft.VisualStudio.Workload.MSBuildTools",
    "--add", "Microsoft.VisualStudio.Component.Windows10SDK",
    "--add", "Microsoft.VisualStudio.Component.VC.CoreBuildTools",
    "--add", "Microsoft.VisualStudio.Component.VC.Tools.x86.x64",
    "--add", "Microsoft.VisualStudio.Component.VC.Redist.14.Latest",
    "--add", "Microsoft.VisualStudio.Component.Windows10SDK.18362",
    "--add", "Microsoft.VisualStudio.Workload.VCTool"
)

RefreshEnvironmentVariables
