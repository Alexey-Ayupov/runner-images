using module ./software-report-base/SoftwareReport.psm1
using module ./software-report-base/SoftwareReport.Nodes.psm1

$global:ErrorActionPreference = "Stop"
$global:ProgressPreference = "SilentlyContinue"
$ErrorView = "NormalView"
Set-StrictMode -Version Latest

Import-Module (Join-Path $PSScriptRoot "SoftwareReport.Android.psm1") -DisableNameChecking
Import-Module (Join-Path $PSScriptRoot "SoftwareReport.Browsers.psm1") -DisableNameChecking
Import-Module (Join-Path $PSScriptRoot "SoftwareReport.CachedTools.psm1") -DisableNameChecking
Import-Module (Join-Path $PSScriptRoot "SoftwareReport.Common.psm1") -DisableNameChecking
Import-Module (Join-Path $PSScriptRoot "SoftwareReport.Databases.psm1") -DisableNameChecking
Import-Module (Join-Path $PSScriptRoot "SoftwareReport.Helpers.psm1") -DisableNameChecking
Import-Module (Join-Path $PSScriptRoot "SoftwareReport.Tools.psm1") -DisableNameChecking
Import-Module (Join-Path $PSScriptRoot "SoftwareReport.Java.psm1") -DisableNameChecking
Import-Module (Join-Path $PSScriptRoot "SoftwareReport.WebServers.psm1") -DisableNameChecking
Import-Module (Join-Path $PSScriptRoot "SoftwareReport.VisualStudio.psm1") -DisableNameChecking

# Software report
$softwareReport = [SoftwareReport]::new($(Build-OSInfoSection))
$installedSoftware = $softwareReport.Root.AddHeader("Installed Software")

# Your software here

# Generate reports
$softwareReport.ToJson() | Out-File -FilePath "C:\software-report.json" -Encoding UTF8NoBOM
$softwareReport.ToMarkdown() | Out-File -FilePath "C:\software-report.md" -Encoding UTF8NoBOM
