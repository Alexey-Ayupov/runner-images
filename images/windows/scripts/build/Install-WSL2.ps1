Write-Host "Install WSL2"

Write-Host "`$env:TRY_TO_INSTALL - $env:TRY_TO_INSTALL"

if ($env:TRY_TO_INSTALL -eq "'1'") {
    $version = (Get-GithubReleasesByVersion -Repo "microsoft/WSL" -Version "latest").version
    $downloadUrl =  Resolve-GithubReleaseAssetUrl `
        -Repo "microsoft/WSL" `
        -Version $version `
        -UrlMatchPattern "wsl.*.x64.msi"

    Install-Binary -Type MSI `
        -Url $downloadUrl `
        -ExpectedSHA256Sum "CD3F2A68A1A5836F6A1CC9965A7F5F54DB267CA221EAA87DF29345AB7957AEC4"

    Write-Host "Performing wsl --install --no-distribution"
    wsl.exe --install --no-distribution

} elseif ($env:TRY_TO_INSTALL -eq "'2'") {
    Write-Host "Performing wsl --install Ubuntu --no-launch"
    wsl.exe --install Ubuntu --no-launch
    Write-Host "Make the user root the default user"
    ubuntu.exe -install --root
    Write-Host "Get wsl status"
    wsl.exe --status
    Write-Host "Get os-release from Ubuntu"
    wsl.exe -d Ubuntu cat /etc/os-release
    Write-host "Uninstalling Ubuntu distribution"
    wsl.exe --unregister Ubuntu
    Get-AppxPackage | Where-Object {$_.Name -match "Ubuntu"} | Remove-AppxPackage -AllUsers

    #Invoke-PesterTests -TestFile "WindowsFeatures" -TestName "WSL2"
}
