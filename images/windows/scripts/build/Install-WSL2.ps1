Write-Host "Install WSL2"

Write-Host "`$env:TRY_TO_INSTALL - $env:TRY_TO_INSTALL"

if (Test-IsWin25) {
    $filePath = Invoke-DownloadWithRetry -Url "https://download.sysinternals.com/files/SDelete.zip"
    $setupPath = Join-Path $env:TEMP_DIR "sDelete"
    if (-not (Test-Path -Path $setupPath)) {
        New-Item -Path $setupPath -ItemType Directory -Force | Out-Null
    }
    Expand-7ZipArchive -Path $filePath -DestinationPath $setupPath
    & $setupPath\sdelete64.exe -z C: /accepteula
}

if ($env:TRY_TO_INSTALL -eq "'1'") {
    $version = (Get-GithubReleasesByVersion -Repo "microsoft/WSL" -Version "latest").version
    $downloadUrl =  Resolve-GithubReleaseAssetUrl `
        -Repo "microsoft/WSL" `
        -Version $version `
        -UrlMatchPattern "wsl.*.x64.msi"

    Install-Binary -Type MSI `
        -Url $downloadUrl `
        -ExpectedSHA256Sum "CD3F2A68A1A5836F6A1CC9965A7F5F54DB267CA221EAA87DF29345AB7957AEC4"

    Write-Host "performing wsl --install --no-distribution"
    wsl.exe --install --no-distribution
    Write-Host "finished!!!"

} elseif ($env:TRY_TO_INSTALL -eq "'2'") {
    wsl.exe --status
    Write-Host "Getting exact WSL version"
    $WSLappxVersion = (Get-AppxPackage -Name "MicrosoftCorporationII.WindowsSubsystemForLinux").version
    wsl.exe --status | Out-File "C:\image\wsl.log"
    Write-Host "WSL version: $WSLappxVersion"
    #Write-Host "Installing Ubuntu"
    #wsl.exe --install Ubuntu | Out-File "C:\image\wsl.log" -Append
}
