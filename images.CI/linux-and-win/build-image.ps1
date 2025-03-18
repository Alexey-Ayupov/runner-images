param(
    [String] [Parameter (Mandatory=$true)] $TemplatePath,
    [String] [Parameter (Mandatory=$true)] $ClientId,
    [String] [Parameter (Mandatory=$false)] $ClientSecret,
    [String] [Parameter (Mandatory=$false)] $Location,
    [String] [Parameter (Mandatory=$true)] $ImageName,
    [String] [Parameter (Mandatory=$true)] $ImageResourceGroupName,
    [String] [Parameter (Mandatory=$false)] $TempResourceGroupName,
    [String] [Parameter (Mandatory=$true)] $SubscriptionId,
    [String] [Parameter (Mandatory=$true)] $TenantId,
    [String] [Parameter (Mandatory=$false)] $pluginVersion = "2.2.1",
    [String] [Parameter (Mandatory=$false)] $VirtualNetworkName,
    [String] [Parameter (Mandatory=$false)] $VirtualNetworkRG,
    [String] [Parameter (Mandatory=$false)] $VirtualNetworkSubnet,
    [String] [Parameter (Mandatory=$false)] $AllowedInboundIpAddresses = "[]",
    [hashtable] [Parameter (Mandatory=$false)] $Tags = @{},
    [array] [Parameter (Mandatory=$false)] $additionalScripts = @()
)

if (-not (Test-Path $TemplatePath))
{
    Write-Error "'-TemplatePath' parameter is not valid. You have to specify correct Template Path"
    exit 1
}

$ImageTemplateName = [io.path]::GetFileName($TemplatePath).Split(".")[0]
$InstallPassword = [System.GUID]::NewGuid().ToString().ToUpper()

$SensitiveData = @(
    'OSType',
    'StorageAccountLocation',
    'OSDiskUri',
    'OSDiskUriReadOnlySas',
    'TemplateUri',
    'TemplateUriReadOnlySas',
    ':  ->'
)

$azure_tags = $Tags | ConvertTo-Json -Compress

Write-Host $additionalScripts

if (! [string]::IsNullOrEmpty($additionalScripts) ) {
    $updatedScripts = @()
    foreach ($script in $additionalScripts) {
        $updatedScripts += '{0}/{1}'  -f "`${path.root}/../scripts/build", $script
    }
    $updatedScripts = $updatedScripts | ConvertTo-Json -AsArray -Compress
} else {
    $updatedScripts = "[]"
}

$buildRGName = "poc-imagegen-rg"
$buildKVname = "poc-imagegen-kv02"
$buildKVSecretName = "poc-test-secret"

Write-Host $updatedScripts

Write-Host "Show Packer Version"
packer --version

Write-Host "Download packer plugins"
packer plugins install github.com/hashicorp/azure $pluginVersion

Write-Host "Validate packer template"
packer validate -syntax-only $TemplatePath

packer inspect $TemplatePath

Write-Host "Build $ImageTemplateName VM"
packer build    -var "client_id=$ClientId" `
                -var "client_secret=$ClientSecret" `
                -var "install_password=$InstallPassword" `
                -var "managed_image_name=$ImageName" `
                -var "managed_image_resource_group_name=$ImageResourceGroupName" `
                -var "subscription_id=$SubscriptionId" `
                -var "build_resource_group_name=$buildRGName" `
                -var "build_key_vault_name=$buildKVname" `
                -var "build_key_vault_secret_name=$buildKVSecretName" `
                -var "tenant_id=$TenantId" `
                -var "virtual_network_name=$VirtualNetworkName" `
                -var "virtual_network_resource_group_name=$VirtualNetworkRG" `
                -var "virtual_network_subnet_name=$VirtualNetworkSubnet" `
                -var "allowed_inbound_ip_addresses=$($AllowedInboundIpAddresses)" `
                -var "azure_tags=$azure_tags" `
                -color=false `
                $TemplatePath `
        | Where-Object {
            #Filter sensitive data from Packer logs
            $currentString = $_
            $sensitiveString = $SensitiveData | Where-Object { $currentString -match $_ }
            $sensitiveString -eq $null
        }
