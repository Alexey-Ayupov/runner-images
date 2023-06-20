param(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string] $TemplateName,

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string] $RegistryUrl
)

$templateJson = anka --machine-readable list $TemplateName | ConvertFrom-Json
$status = $templateJson.Status
$AnkaCaCrtPath="$HOME/.config/anka/certs/anka-ca-crt.pem"

if ($status -eq "OK") {
    Write-Host "Deleting $TemplateName VM template and tags"
    anka delete $TemplateName --yes
}

Write-Host "Pulling the latest $TemplateName VM template"
anka registry --cacert $AnkaCaCrtPath -a $RegistryUrl pull $TemplateName

$result = anka --machine-readable list $TemplateName | ConvertFrom-Json
if ($result.code) {
    $message = $result | Out-String
    Write-Host "Unable to download the $TemplateName VM template from $RegistryUrl registry"
    Write-Host "Error:`n$message"
    exit 1
}
