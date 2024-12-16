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

} elseif ($env:TRY_TO_INSTALL -eq "'2'") {
    Write-Host "Getting exact WSL version"
    $WSLappxVersion = (Get-AppxPackage -Name "MicrosoftCorporationII.WindowsSubsystemForLinux").version
    & wsl --status | Out-File "C:\image\wsl.log"
    Write-Host "WSL version: $WSLappxVersion"
    Write-Host "Installing Ubuntu"
    & wsl --install Ubuntu | Out-File "C:\image\wsl.log" -Append
}
