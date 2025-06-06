variable "agent_tools_directory" {
  type    = string
  default = "C:\\hostedtoolcache\\windows"
}

variable "allowed_inbound_ip_addresses" {
  type    = list(string)
  default = []
}

variable "azure_tags" {
  type    = map(string)
  default = {}
}

variable "build_resource_group_name" {
  type    = string
  default = "${env("BUILD_RG_NAME")}"
}

variable "client_cert_path" {
  type    = string
  default = "${env("ARM_CLIENT_CERT_PATH")}"
}

variable "client_id" {
  type    = string
  default = "${env("ARM_CLIENT_ID")}"
}

variable "client_secret" {
  type      = string
  default   = "${env("ARM_CLIENT_SECRET")}"
  sensitive = true
}

variable "helper_script_folder" {
  type    = string
  default = "C:\\Program Files\\WindowsPowerShell\\Modules\\"
}

variable "image_folder" {
  type    = string
  default = "C:\\image"
}

variable "image_os" {
  type    = string
  default = "win22"
}

variable "image_version" {
  type    = string
  default = "dev"
}

variable "imagedata_file" {
  type    = string
  default = "C:\\imagedata.json"
}

variable "temp_dir" {
  type    = string
  default = "D:\\temp"
}

variable "install_password" {
  type      = string
  default   = ""
  sensitive = true
}

variable "install_user" {
  type    = string
  default = "installer"
}

variable "location" {
  type    = string
  default = ""
}

variable "managed_image_name" {
  type    = string
  default = ""
}

variable "managed_image_resource_group_name" {
  type    = string
  default = "${env("ARM_RESOURCE_GROUP")}"
}

variable "managed_image_storage_account_type" {
  type    = string
  default = "Premium_LRS"
}

variable "object_id" {
  type    = string
  default = "${env("ARM_OBJECT_ID")}"
}

variable "private_virtual_network_with_public_ip" {
  type    = bool
  default = false
}

variable "subscription_id" {
  type    = string
  default = "${env("ARM_SUBSCRIPTION_ID")}"
}

variable "temp_resource_group_name" {
  type    = string
  default = "${env("TEMP_RESOURCE_GROUP_NAME")}"
}

variable "tenant_id" {
  type    = string
  default = "${env("ARM_TENANT_ID")}"
}

variable "virtual_network_name" {
  type    = string
  default = "${env("VNET_NAME")}"
}

variable "virtual_network_resource_group_name" {
  type    = string
  default = "${env("VNET_RESOURCE_GROUP")}"
}

variable "virtual_network_subnet_name" {
  type    = string
  default = "${env("VNET_SUBNET")}"
}

variable "vm_size" {
  type    = string
  default = "Standard_F8s_v2"
}

variable "image_offer" {
  type    = string
  default = "WindowsServer"
}

variable "image_publisher" {
  type    = string
  default = "MicrosoftWindowsServer"
}

variable "image_sku" {
  type    = string
  default = "2022-Datacenter"
}

variable "gallery_name" {
  type    = string
  default = "${env("GALLERY_NAME")}"
}

variable "gallery_resource_group_name" {
  type    = string
  default = "${env("GALLERY_RG_NAME")}"
}

variable "gallery_image_name" {
  type    = string
  default = "${env("GALLERY_IMAGE_NAME")}"
}

variable "gallery_image_version" {
  type    = string
  default = "${env("GALLERY_IMAGE_VERSION")}"
}

variable "gallery_storage_account_type" {
  type    = string
  default = "${env("GALLERY_STORAGE_ACCOUNT_TYPE")}"
}

variable "build_key_vault_name" {
  type    = string
  default = "${env("BUILD_KEY_VAULT_NAME")}"
}

variable "build_key_vault_secret_name" {
  type    = string
  default = "${env("BUILD_KEY_VAULT_SECRET_NAME")}"
}

variable "use_azure_cli_auth" {
  type    = bool
  default = false
}

variable "os_disk_size_gb" {
  type    = number
  default = 256
}

variable "image_os_type" {
  type    = string
  default = "Windows"
}

source "azure-arm" "image" {
  allowed_inbound_ip_addresses           = "${var.allowed_inbound_ip_addresses}"
  build_resource_group_name              = "${var.build_resource_group_name}"
  client_cert_path                       = "${var.client_cert_path}"
  client_id                              = "${var.client_id}"
  client_secret                          = "${var.client_secret}"
  use_azure_cli_auth                     = var.use_azure_cli_auth
  communicator                           = "winrm"
  image_offer                            = "${var.image_offer}"
  image_publisher                        = "${var.image_publisher}"
  image_sku                              = "${var.image_sku}"
  location                               = "${var.location}"
  managed_image_name                     = "${var.managed_image_name}"
  managed_image_resource_group_name      = "${var.managed_image_resource_group_name}"
  managed_image_storage_account_type     = "${var.managed_image_storage_account_type}"
  object_id                              = "${var.object_id}"
  os_disk_size_gb                        = var.os_disk_size_gb
  os_type                                = var.image_os_type
  private_virtual_network_with_public_ip = "${var.private_virtual_network_with_public_ip}"
  subscription_id                        = "${var.subscription_id}"
  temp_resource_group_name               = "${var.temp_resource_group_name}"
  tenant_id                              = "${var.tenant_id}"
  virtual_network_name                   = "${var.virtual_network_name}"
  virtual_network_resource_group_name    = "${var.virtual_network_resource_group_name}"
  virtual_network_subnet_name            = "${var.virtual_network_subnet_name}"
  vm_size                                = "${var.vm_size}"
  winrm_insecure                         = "true"
  winrm_use_ssl                          = "true"
  winrm_username                         = "packer"
  winrm_expiration_time                  = "1440h"
  build_key_vault_name                   = var.build_key_vault_name
  build_key_vault_secret_name            = var.build_key_vault_secret_name

  shared_image_gallery_destination {
    subscription                         = var.subscription_id
    gallery_name                         = var.gallery_name
    resource_group                       = var.gallery_resource_group_name
    image_name                           = var.gallery_image_name
    image_version                        = var.gallery_image_version
    storage_account_type                 = var.gallery_storage_account_type
  }

  dynamic "azure_tag" {
    for_each = var.azure_tags
    content {
      name  = azure_tag.key
      value = azure_tag.value
    }
  }
}

build {
  sources = ["source.azure-arm.image"]

  provisioner "powershell" {
    inline = [
      "write-host \"image_folder variable -${var.image_folder}\"",
      "New-Item -Path \"C:\\image\" -ItemType Directory -Force",
      "write-host \"temp_dir variable -${var.temp_dir}\"",
      "New-Item -Path \"D:\\temp\" -ItemType Directory -Force"
    ]
  }

  provisioner "file" {
    destination = "${var.image_folder}\\"
    sources     = [
      "${path.root}/../assets",
      "${path.root}/../scripts",
      "${path.root}/../toolsets"
    ]
  }

  provisioner "file" {
    destination = "${var.image_folder}\\scripts\\docs-gen\\"
    source      = "${path.root}/../../../helpers/software-report-base"
  }

  provisioner "powershell" {
    inline = [
      "Move-Item '${var.image_folder}\\assets\\post-gen' 'C:\\post-generation'",
      "Remove-Item -Recurse '${var.image_folder}\\assets'",
      "Move-Item '${var.image_folder}\\scripts\\docs-gen' '${var.image_folder}\\SoftwareReport'",
      "Move-Item '${var.image_folder}\\scripts\\helpers' '${var.helper_script_folder}\\ImageHelpers'",
      "New-Item -Type Directory -Path '${var.helper_script_folder}\\TestsHelpers\\'",
      "Move-Item '${var.image_folder}\\scripts\\tests\\Helpers.psm1' '${var.helper_script_folder}\\TestsHelpers\\TestsHelpers.psm1'",
      "Move-Item '${var.image_folder}\\scripts\\tests' '${var.image_folder}\\tests'",
      "Remove-Item -Recurse '${var.image_folder}\\scripts'",
      "Move-Item '${var.image_folder}\\toolsets\\toolset-2022.json' '${var.image_folder}\\toolset.json'",
      "Remove-Item -Recurse '${var.image_folder}\\toolsets'"
    ]
  }

  provisioner "windows-shell" {
    inline = [
      "net user ${var.install_user} ${var.install_password} /add /passwordchg:no /passwordreq:yes /active:yes /Y",
      "net localgroup Administrators ${var.install_user} /add",
      "winrm set winrm/config/service/auth @{Basic=\"true\"}",
      "winrm get winrm/config/service/auth"
    ]
  }

  provisioner "powershell" {
    inline = ["if (-not ((net localgroup Administrators) -contains '${var.install_user}')) { exit 1 }"]
  }

  provisioner "powershell" {
    elevated_password = "${var.install_password}"
    elevated_user     = "${var.install_user}"
    inline            = ["bcdedit.exe /set TESTSIGNING ON"]
  }

  provisioner "powershell" {
    inline = ["Set-Content -Value 'Debug in progress' -Path 'C:\\software-report.md'", "Set-Content -Value '{\"Image\":\"Debug in progress\"}' -Path 'C:\\software-report.json'", "if (-not (Test-Path C:\\software-report.md)) { throw 'C:\\software-report.md not found' }", "if (-not (Test-Path C:\\software-report.json)) { throw 'C:\\software-report.json not found' }"]
  }

  provisioner "file" {
    destination = "${path.root}/../Windows2022-Readme.md"
    direction   = "download"
    source      = "C:\\software-report.md"
  }

  provisioner "file" {
    destination = "${path.root}/../software-report.json"
    direction   = "download"
    source      = "C:\\software-report.json"
  }

  provisioner "powershell" {
    inline = [
      "Set-Service RdAgent -StartupType Disabled -ErrorAction Continue",
      "Set-Service WindowsAzureTelemetryService -StartupType Disabled -ErrorAction Continue",
      "Set-Service WindowsAzureGuestAgent -StartupType Disabled -ErrorAction Continue",
      "Remove-ItemProperty -Path 'HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Setup\\SysPrepExternal\\Generalize' -Name '*'"
    ]
  }

  provisioner "windows-restart" {
    restart_timeout = "10m"
  }

  provisioner "powershell" {
    inline = [
      "if( Test-Path $env:SystemRoot\\System32\\Sysprep\\unattend.xml ){ rm $env:SystemRoot\\System32\\Sysprep\\unattend.xml -Force}",
      "& $env:SystemRoot\\System32\\Sysprep\\Sysprep.exe /oobe /generalize /mode:vm /quiet /quit",
      "while($true) { $imageState = Get-ItemProperty HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Setup\\State | Select ImageState; if($imageState.ImageState -ne 'IMAGE_STATE_GENERALIZE_RESEAL_TO_OOBE') { Write-Output $imageState.ImageState; Start-Sleep -s 10 } else { break } }"
    ]
  }

}
