################################################################################
##  File:  Install-ChocolateyPackages.ps1
##  Desc:  Install common Chocolatey packages
################################################################################

<#metadata
{
    "dependsOn": "Install-Chocolatey.ps1",
    "file": "Install-ChocolateyPackages.ps1",
    "description": "Install common Chocolatey packages",
    "softwareReport": {
        "osSupported": [
            "win19",
            "win22",
            "win25"
        ],
        "header": "Tools Installed Via Chocolatey",
        "varName": "tools",
        "name": "7zip.install, aria2, azcopy10, Bicep, jq, NuGet.CommandLine, packer, strawberryperl, pulumi, swig, vswhere, julia, cmake.install, imagemagick",
        "function": "Get-7zipVersion, Get-Aria2Version, Get-AzCopyVersion, Get-BicepVersion, Get-JQVersion, Get-NugetVersion, Get-PackerVersion, Get-PerlVersion, Get-PulumiVersion, Get-SwigVersion, Get-VSWhereVersion, Get-JuliaVersion, Get-CMakeVersion, Get-ImageMagickVersion"
    }
}
metadata#>

$commonPackages = (Get-ToolsetContent).choco.common_packages

foreach ($package in $commonPackages) {
    Install-ChocoPackage $package.name -ArgumentList $package.args
}

Invoke-PesterTests -TestFile "ChocoPackages"
