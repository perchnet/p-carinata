locals {
  data_vm_node_name = var.data_vm_node_name != null ? var.data_vm_node_name : var.node_name # data_node_name defaults to null and falls through to node_name
}
resource "proxmox_virtual_environment_vm" "data_vm" {
  name      = var.data_vm_name != null ? var.data_vm_name : "${var.vm_name}.data"
  description = <<-EOT
  # Managed data VM for p-carinata
  ## ⚠ Warning:
  Do not start this VM directly. It is intended to be used as a data disk source for other VMs.
  EOT
  node_name = local.data_vm_node_name
  started   = false
  on_boot   = false

  network_device {
    bridge = "inhibit_start" # this bridge does not exist, which will prevent the VM from starting
  }

  dynamic "disk" {
    for_each = var.data_vm_disks
    content {
      datastore_id = disk.value.datastore_id != null ? disk.value.datastore_id : local.data_vm_disks_datastore
      interface    = "scsi${disk.key + 1}"
      size         = disk.value.size
    }
  }
}

locals {
  data_vm_disks_datastore = var.data_vm_disks_datastore != null ? var.data_vm_disks_datastore : var.datastore
}