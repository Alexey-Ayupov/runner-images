locals {
  managed_image_name = var.managed_image_name != "" ? var.managed_image_name : "packer-${var.image_os}-${var.image_version}"
  user_data_file = var.user_data_file == "true" ? "${path.root}/userdata.ps1" : ""
}

source "azure-arm" "image" {
  allowed_inbound_ip_addresses           = "${var.allowed_inbound_ip_addresses}"
  build_resource_group_name              = "${var.build_resource_group_name}"
  client_cert_path                       = "${var.client_cert_path}"
  client_id                              = "${var.client_id}"
  client_secret                          = "${var.client_secret}"
  communicator                           = "winrm"
  image_offer                            = "${var.image_offer}"
  image_publisher                        = "${var.image_publisher}"
  image_sku                              = "${var.image_sku}"
  location                               = "${var.location}"
  managed_image_name                     = "${local.managed_image_name}"
  managed_image_resource_group_name      = "${var.managed_image_resource_group_name}"
  managed_image_storage_account_type     = "${var.managed_image_storage_account_type}"
  os_disk_size_gb                        = "150"
  os_type                                = "Windows"
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
  custom_script                          = "${var.custom_script}"
  user_data_file                         = "${local.user_data_file}"
  skip_create_build_key_vault            = "${var.skip_create_build_key_vault}"
  oidc_request_token                     = "${var.oidc_request_token}"
  oidc_request_url                       = "${var.oidc_request_url}"

  dynamic "azure_tag" {
    for_each = var.azure_tags
    content {
      name  = azure_tag.key
      value = azure_tag.value
    }
  }
}
