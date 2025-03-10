using 'main.bicep'

param location = 'eastus'
param virtualNetworkRG = 'gh-imagegen-vnet-rg'
param virtualNetworkName = 'gh-imagegen-vnet'
param delegatedSubnetNSGName = 'gh-delegated-subnet-nsg'

param galleryRG  = 'gh-imagegen-gallery-rg'
param galleryName  = 'gh_imagegen_gallery'

param storageRG  = 'gh-imagegen-storage-rg'
param storageAccountName = 'ghimagegenstorage'
param containerNames = [
  'nvidia-gpu-optimized'
  'winserver-2019-dsvm'
  'winserver-2019'
  'winserver-2022'
  'github-linux'
  'win11-23h2-ent'
  'win11-23h2-ent-arm64'
  'github-arm-linux-runner-plan-2404'
  'github-arm-linux-runner'
  '22-04-lts-arm64'
  '20-04-lts-arm64'
  '22-04-lts'
  '20-04-lts'
]

param imageDefinitionConfig = [
  {
    name: 'gpu-optimized-nvidia'
    publisher: 'nvidia'
    offer: 'ngc_azure_17_11'
    sku: 'gpu_optimized_24_10_1_gen2'
    architecture: 'x64'
    osType: 'Linux'
    purchasePlan: {
      name: 'gpu_optimized_24_10_1_gen2'
      product: 'ngc_azure_17_11'
      publisher: 'nvidia'
    }
  }
  {
    name: 'winserver-2019-dsvm'
    publisher: 'microsoft-dsvm'
    offer: 'winserver-2019'
    sku: 'win11-23h2-ent'
    architecture: 'x64'
    osType: 'Windows'
    purchasePlan: {}
  }
  {
    name: 'github-linux'
    publisher: 'arm'
    offer: 'avh_custom_runner'
    sku: 'github'
    architecture: 'x64'
    osType: 'Linux'
    purchasePlan: {}
  }
  {
    name: 'win11-23h2-ent'
    publisher: 'MicrosoftWindowsDesktop'
    offer: 'windows-11'
    sku: 'win11-23h2-ent'
    architecture: 'x64'
    osType: 'Windows'
    purchasePlan: {}
  }
  {
    name: 'win11-23h2-ent-arm64'
    publisher: 'MicrosoftWindowsDesktop'
    offer: 'windows11preview-arm64'
    sku: 'win11-23h2-ent'
    architecture: 'Arm64'
    osType: 'Windows'
    purchasePlan: {}
  }
  {
    name: 'github-arm-linux-runner-plan-2404'
    publisher: 'arm'
    offer: 'github_arm_linux_runner_2404'
    sku: 'github_arm_linux_runner_plan_2404'
    architecture: 'Arm64'
    osType: 'Linux'
    purchasePlan: {}
  }
  {
    name: 'github-arm-linux-runner'
    publisher: 'arm'
    offer: 'github_arm_linux_runner'
    sku: 'github_arm_linux_runner_plan'
    architecture: 'Arm64'
    osType: 'Linux'
    purchasePlan: {}
  }
  {
    name: '22-04-lts-arm64'
    publisher: 'canonical'
    offer: '0001-com-ubuntu-server-jammy'
    sku: '22_04-lts-arm64'
    architecture: 'Arm64'
    osType: 'Linux'
    purchasePlan: {}
  }
  {
    name: '20-04-lts-arm64'
    publisher: 'canonical'
    offer: '0001-com-ubuntu-server-focal'
    sku: '20_04-lts-arm64'
    architecture: 'Arm64'
    osType: 'Linux'
    purchasePlan: {}
  }
  {
    name: '22-04-lts'
    publisher: 'canonical'
    offer: '0001-com-ubuntu-server-jammy'
    sku: '22_04-lts'
    architecture: 'x64'
    osType: 'Linux'
    purchasePlan: {}
  }
  {
    name: '20-04-lts'
    publisher: 'canonical'
    offer: '0001-com-ubuntu-server-focal'
    sku: '20_04-lts'
    architecture: 'x64'
    osType: 'Linux'
    purchasePlan: {}
  }
  {
    name: '2022-datacenter'
    publisher: 'microsoftwindowsserver'
    offer: 'windowsserver'
    sku: '2022-datacenter'
    architecture: 'x64'
    osType: 'Windows'
    purchasePlan: {}
  }
  {
    name: '2019-datacenter'
    publisher: 'microsoftwindowsserver'
    offer: 'windowsserver'
    sku: '2019-datacenter'
    architecture: 'x64'
    osType: 'Windows'
    purchasePlan: {}
  }
]
