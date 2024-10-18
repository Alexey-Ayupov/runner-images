####################################################################################
##  File:  Install-Hyper-V.ps1
##  Desc:  Install Hyper-V Windows Feature
####################################################################################

Write-Host "Activating Windows Feature 'Hyper-V'..."
$arguments = @{
    Name                   = "Hyper-V"
    IncludeAllSubFeature   = $true
    IncludeManagementTools = $true
}
$result = Install-WindowsFeature @arguments

$resultSuccess = $result.Success

if ($resultSuccess) {
    Write-Host "Windows Feature 'Hyper-V' was activated successfully"
} else {
    throw "Failed to activate Windows Feature 'Hyper-V'"
}

# it improves Android emulator launch on Windows Server
# https://learn.microsoft.com/en-us/windows-server/virtualization/hyper-v/manage/manage-hyper-v-scheduler-types
bcdedit /set hypervisorschedulertype root
if ($LASTEXITCODE -ne 0) {
    throw "Failed to set hypervisorschedulertype to root"
}
