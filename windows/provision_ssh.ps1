# Source common code from file
. $PSScriptRoot/provision_common.ps1

# $sshPublicKeyFilename = "id_ed25519.pub"
# $sshPublicKeyFullPath = "$provisioningDirectory\$sshPublicKeyFilename"

# $vmUser = "IEUser"
# $sshParentDirectory = "C:\Users\$vmUser"
# $sshDirectory = "$sshParentDirectory\.ssh"

# From:
# https://docs.microsoft.com/en-us/windows-server/administration/openssh/openssh_install_firstuse

Write-Host "Enabling OpenSSH..."
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

# https://www.powershellgallery.com/packages/OpenSSHUtils/0.0.2.0
# FIXME: This seems to block and never finish...
# Write-Host "Installing OpenSSHUtil..."
# Install-Module -Name OpenSSHUtils

# Start the service
Write-Host "Configuring OpenSSH Windows service..."
Start-Service sshd
# Set service start to automatic
Set-Service -Name sshd -StartupType 'Automatic'
# Confirm the Firewall rule is configured. It should be created automatically by setup. 
Get-NetFirewallRule -Name *ssh*
# There should be a firewall rule named "OpenSSH-Server-In-TCP", which should be enabled 

# Configuring OpenSSH
# https://docs.microsoft.com/en-us/windows-server/administration/openssh/openssh_server_configuration
# Set PowerShell as the default shell
# See https://docs.microsoft.com/en-us/windows-server/administration/openssh/openssh_server_configuration
New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -PropertyType String -Force

# Copy public key into authorized_keys for passwordless ssh connections
# https://winscp.net/eng/docs/guide_windows_openssh_server#key_authentication
# FIXME: Not working :(
#       Some notes:
#           https://superuser.com/questions/1342411/setting-ssh-keys-on-windows-10-openssh-server
#           https://winscp.net/eng/docs/guide_windows_openssh_server#key_authentication
#           https://superuser.com/questions/1415983/windows-10-sshd-passwordless-incoming-ssh-demands-a-password
#           https://superuser.com/questions/1041957/how-to-properly-configure-win32-openssh-authentication
#           ACL permissions: https://blogs.msdn.microsoft.com/johan/2008/10/01/powershell-editing-permissions-on-a-file-or-folder/
# Use `-Force` to create destination directory
# Write-Host "Copying SSH public key"
# New-Item -Force -Path "$sshParentDirectory" -Name ".ssh" -ItemType "directory"
# Copy-Item -Force "$sshPublicKeyFullPath" -Destination "$sshDirectory\authorized_keys"
# Fix permissions
# $Acl = Get-Acl $sshDirectory
# $Acl.RemoveAccessRuleAll()
