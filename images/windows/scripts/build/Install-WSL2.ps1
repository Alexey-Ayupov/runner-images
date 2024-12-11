Write-Host "Install WSL2"

$ErrorActionPreviousValue = $ErrorActionPreference
$ErrorActionPreference = 'SilentlyContinue'

wsl.exe --status
if ($env:TRY_TO_INSTALL -eq "1") {
    wsl.exe --install
} elseif ($env:TRY_TO_INSTALL -eq "2") {
    wsl.exe --install Ubuntu
}

$ErrorActionPreference = $ErrorActionPreviousValue
