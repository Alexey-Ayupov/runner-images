Write-Host "Install WSL2"

$ErrorActionPreviousValue = $ErrorActionPreference
$ErrorActionPreference = 'SilentlyContinue'

& wsl --status | Out-File -FilePath "C:\image\wsl-logs.txt"
if ($env:TRY_TO_INSTALL -eq "1") {
    $wsllog = & wsl --install | Out-File -FilePath "C:\image\wsl-logs.txt" -Append
    Write-Host $wsllog
} elseif ($env:TRY_TO_INSTALL -eq "2") {
    $wsllog = & wsl --install Ubuntu | Out-File -FilePath "C:\image\wsl-logs.txt" -Append
    Write-Host $wsllog
}

Get-Content-path "C:\image\wsl-logs.txt"

$ErrorActionPreference = $ErrorActionPreviousValue
