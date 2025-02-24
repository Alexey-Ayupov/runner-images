build {
  sources = ["source.azure-arm.image"]

  provisioner "powershell" {
    environment_vars = ["IMAGE_FOLDER=${var.image_folder}", "TEMP_DIR=${var.temp_dir}"]
    scripts          = [
      "${path.root}/../../scripts/build/Install-AndroidSDK.ps1",
    ]
  }

}
