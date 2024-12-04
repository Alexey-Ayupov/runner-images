$scriptFile = Get-Content -Path "C:\work\runner-images\images\windows\scripts\build\Install-AliyunCli.ps1"

for ($i = 0; $i -lt $scriptFile.Length; $i++) {
    if ($scriptFile[$i] -match "<#metadata") {
        Write-Host "Start of metadata block found at line $i"
        $beginMetaData = $i+1
    }
    if ($scriptFile[$i] -match "metadata#>") {
        Write-Host "End of metadata block found at line $i"
        $endMetaData = $i-1
    }
}

$metadataObject =  $scriptFile[$beginMetaData..$endMetaData] | ConvertFrom-Json

get-content -path "C:\work\runner-images\images\windows\scripts\docs-gen\Generate-SoftwareReport.ps1" -TotalCount 21 |
    Set-Content -Path "C:\work\runner-images\images\windows\scripts\docs-gen\Generate-SoftwareReport-test.ps1"

Add-Content -Path "C:\work\runner-images\images\windows\scripts\docs-gen\Generate-SoftwareReport-test.ps1" `
            -Value '$installedSoftware = $softwareReport.Root.AddHeader("Installed Software")'
Add-Content -Path "C:\work\runner-images\images\windows\scripts\docs-gen\Generate-SoftwareReport-test.ps1" `
            -Value "`$victim = `$installedSoftware.AddHeader(`"$($metadataObject.softwareReport.Header)`")"
Add-Content -Path "C:\work\runner-images\images\windows\scripts\docs-gen\Generate-SoftwareReport-test.ps1" `
            -Value "`$victim.AddToolVersion(`"$($metadataObject.softwareReport.name)`", `$($($metadataObject.softwareReport.function)))"
Add-Content -Path "C:\work\runner-images\images\windows\scripts\docs-gen\Generate-SoftwareReport-test.ps1" `
            -Value '$softwareReport.ToJson() | Out-File -FilePath "C:\software-report.json" -Encoding UTF8NoBOM'
Add-Content -Path "C:\work\runner-images\images\windows\scripts\docs-gen\Generate-SoftwareReport-test.ps1" `
            -Value '$softwareReport.ToMarkdown() | Out-File -FilePath "C:\software-report.md" -Encoding UTF8NoBOM'
