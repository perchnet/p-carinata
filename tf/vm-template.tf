resource "proxmox_virtual_environment_download_file" "carinata_cloud_image" {
  overwrite = true
  overwrite_unmanaged = true
  content_type = "import"
  datastore_id = var.qcow2_datastore != null ? var.qcow2_datastore : var.datastore
  node_name    = var.node_name
  url          = var.carinata_cloud_image_url
}

resource "proxmox_virtual_environment_vm" "carinata_template" {
  name      = var.template_name # default carinata_template
  node_name = var.node_name     # default pve1
bios = var.firmware == "uefi" ? "ovmf" : var.firmware == "bios" ? "seabios" : var.firmware

started = false
template = true
  operating_system { type = "l26" }
  scsi_hardware = "virtio-scsi-single"
  disk {
    datastore_id = var.os_disk_datastore != null ? var.os_disk_datastore : var.datastore
    import_from  = proxmox_virtual_environment_download_file.carinata_cloud_image.id
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = var.os_disk_size_gb
  }
  boot_order = ["scsi0"]
}
