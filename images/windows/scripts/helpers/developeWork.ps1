$pullRequestsFiles = @(
    "images/windows/scripts/build/Install-AliyunCli.ps1",
    "images/windows/toolsets/toolset-2019.json",
    "images/windows/toolsets/toolset-2022.json"
)

$scriptsToBuild = @()

foreach ($file in $($pullRequestsFiles | Where-Object {$_ -match ".ps1" -or $_ -match ".sh"})) {
    Write-Host "Processing $file"
    $scriptFile = Get-Content -Path (Join-Path "C:\work\runner-images" $file)

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

    if ($metadataObject.dependsOn -ne "none") {
        Write-Host "Script $($metadataObject.file) depends on $($metadataObject.dependsOn)"
        Write-host "Script(s) $($metadataObject.dependsOn) will be added to the packer template"
        $scriptsToBuild += $metadataObject.file
        $scriptsToBuild += $metadataObject.dependsOn
    }

}




#--------------------Drafts and Development Area--------------------
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



$scriptsLines = @(
    "`$$($metadataObject.softwareReport.varName) = `$installedSoftware.AddHeader(`"$($metadataObject.softwareReport.Header)`")",
    "`$$($metadataObject.softwareReport.varName).AddToolVersion(`"$($metadataObject.softwareReport.name)`", `$($($metadataObject.softwareReport.function)))"
)

$softReport = Get-Content -Path "C:\work\runner-images\images\windows\scripts\docs-gen\Generate-SoftwareReportTemplate.ps1"
$newSoftReport = @()
foreach ($line in $softReport) {
    $newSoftReport += $line
    if ($line -match "# Your software here") {
        $newSoftReport += $scriptsLines
    }
}

Set-Content -Path "C:\work\runner-images\images\windows\scripts\docs-gen\Generate-SoftwareReport-test.ps1" -Value $newSoftReport



$hclitem = @{
    environment_vars = @("TRY_TO_INSTALL='1'", "IMAGE_FOLDER=`${var.image_os}")
    scripts = @("`${path.root}/../scripts/build/Install-some1.ps1", "`${path.root}/../scripts/build/Install-some2.ps1", "`${path.root}/../scripts/build/Install-some3.ps1")
    elevated_password = "`${var.install_password}"
    elevated_user = "`${var.install_user}"
}

foreach ($key in $hclitem.Keys) {
    "{0} = {1}" -f "$key", "$($hclitem.$key | ConvertTo-Json -Compress)"
}

#$testvar = "{0} = {1}" -f "$($hclitem.Keys | Where-Object {$_ -eq "environment_vars"})", "$($hclitem.environment_vars | ConvertTo-Json -Compress)"


<#
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
#>

## https://github.com/orgs/community/discussions/25950

$url = "https://api.github.com/repos/actions/runner-images/pulls/11389.diff"

$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Accept", "application/vnd.github.v3.diff")


$response =  Invoke-RestMethod -Uri $url -Headers $headers -Method Get
