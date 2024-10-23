####################################################################################
##  File:  Install-WindowsFeatures.ps1
##  Desc:  Install Windows Features
####################################################################################

$windowsFeatures = (Get-ToolsetContent).windowsFeatures

foreach ($feature in $windowsFeatures) {
    if ($feature.optionalFeature) {
        Write-Host "Activating Windows Optional Feature '$($feature.name)'..."
        Enable-WindowsOptionalFeature -Online -FeatureName $feature.name -NoRestart

        $resultSuccess = $?
    } else {
        Write-Host "Activating Windows Feature '$($feature.name)'..."
        $arguments = @{
            Name                   = $feature.name
            IncludeAllSubFeature   = [System.Convert]::ToBoolean($feature.includeAllSubFeatures)
            IncludeManagementTools = [System.Convert]::ToBoolean($feature.includeManagementTools)
        }
        $count = 1
        while ($true) {
            $result = Install-WindowsFeature @arguments
            $resultSuccess = $result.Success
            if ($resultSuccess) {
                break
            } else {
                $count++
                if ($count -ge 10) {
                    Write-Host "Could not activate '$($feature.name)' after $count attempts"
                    exit 1
                }
                Start-Sleep -Seconds 10
            }
        }
    }

    if ($resultSuccess) {
        Write-Host "Windows Feature '$($feature.name)' was activated successfully"
    } else {
        throw "Failed to activate Windows Feature '$($feature.name)'"
    }
}

# it improves Android emulator launch on Windows Server
# https://learn.microsoft.com/en-us/windows-server/virtualization/hyper-v/manage/manage-hyper-v-scheduler-types
bcdedit /set hypervisorschedulertype root
if ($LASTEXITCODE -ne 0) {
    throw "Failed to set hypervisorschedulertype to root"
}
