################################################################################
##  File:  Install-AliyunCli.ps1
##  Desc:  Install Alibaba Cloud CLI
##  Supply chain security: Alibaba Cloud CLI - checksum validation
################################################################################

<#metadata
{
    "dependsOn": "none",
    "file": "Install-AliyunCli.ps1",
    "description": "Install Alibaba Cloud CLI",
    "softwareReport": {
        "osSupported": [
            "win19",
            "win22"
        ],
        "header": "CLI Tools",
        "varName": "cliTools",
        "name": "Alibaba Cloud CLI",
        "function": "Get-AlibabaCLIVersion"
    }
}
metadata#>

Write-Host "Download Latest aliyun-cli archive"
$downloadUrl = Resolve-GithubReleaseAssetUrl `
    -Repo "aliyun/aliyun-cli" `
    -Version "latest" `
    -UrlMatchPattern "aliyun-cli-windows-*-amd64.zip"
$packagePath = Invoke-DownloadWithRetry $downloadUrl

#region Supply chain security - Alibaba Cloud CLI
$packageName = Split-Path $downloadUrl -Leaf
$externalHash = Get-ChecksumFromUrl -Type "SHA256" `
    -Url ($downloadUrl -replace $packageName, "SHASUMS256.txt") `
    -FileName $packageName
Test-FileChecksum $packagePath -ExpectedSHA256Sum $externalHash
#endregion

Write-Host "Expand aliyun-cli archive"
$aliyunPath = "C:\aliyun-cli"
New-Item -Path $aliyunPath -ItemType Directory -Force
Expand-7ZipArchive -Path $packagePath -DestinationPath $aliyunPath

# Add aliyun-cli to path
Add-MachinePathItem $aliyunPath

Invoke-PesterTests -TestFile "CLI.Tools" -TestName "Aliyun CLI"
