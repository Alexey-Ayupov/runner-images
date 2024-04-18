#!/bin/bash -e
################################################################################
##  File:  install-powershell.sh
##  Desc:  Install PowerShell Core
################################################################################

# Source the helpers for use with the script
source $HELPER_SCRIPTS/install.sh

pwsh_version=$(get_toolset_value .pwsh.version)

if is_ubuntu24; then
    # Install Powershell
    download_with_retries "https://github.com/PowerShell/PowerShell/releases/download/v7.4.2/powershell-lts_7.4.2-1.deb_amd64.deb" "/tmp"
    dpkg -i /tmp/powershell-lts_7.4.2-1.deb_amd64.deb
else if
    # Install Powershell
    apt-get install -y powershell=$pwsh_version*
fi
