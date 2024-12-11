Write-Host "Install WSL2"

$ErrorActionPreviousValue = $ErrorActionPreference
$ErrorActionPreference = 'SilentlyContinue'

wsl.exe --status
if ($env:TRY_TO_INSTALL -eq "1") {
    $wsllog = wsl.exe --install
    Write-Host $wsllog
} elseif ($env:TRY_TO_INSTALL -eq "2") {
    $wsllog = wsl.exe --install Ubuntu
    Write-Host $wsllog
}

$ErrorActionPreference = $ErrorActionPreviousValue
