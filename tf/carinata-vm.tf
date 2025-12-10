resource "proxmox_virtual_environment_vm" "carinata_vm" {
  clone {
    vm_id = proxmox_virtual_environment_vm.carinata_template.id
    full  = var.vm_clone_full
  }
  name        = var.vm_name
  description = var.vm_description
  node_name   = var.node_name

  agent {
    enabled = var.vm_qemu_agent_enabled
  }
  stop_on_destroy = var.vm_stop_on_destroy != null ? var.vm_stop_on_destroy : var.vm_qemu_agent_enabled
  memory {
    dedicated = var.vm_memory_mb
  }
  network_device {
    bridge = var.vm_bridge
    model  = "virtio"
  }
  initialization {
    datastore_id = var.cloudinit_datastore != null ? var.cloudinit_datastore : var.datastore
    user_account {
      keys     = var.ssh_public_keys
      username = var.vm_username
      password = var.vm_password
    }
    ip_config {
      ipv4 {
        address = var.vm_ipv4_address
        gateway = var.vm_ipv4_gateway
      }
    }
    dns {
      servers = ["4.2.2.1", "4.2.2.2", "4.2.2.3", "4.2.2.4"]
    }
    # attached disks from data_vm
  }
  dynamic "disk" {
    for_each = { for idx, val in proxmox_virtual_environment_vm.data_vm.disk : idx => val }
    iterator = data_disk
    content {
      datastore_id      = data_disk.value["datastore_id"]
      path_in_datastore = data_disk.value["path_in_datastore"]
      file_format       = data_disk.value["file_format"]
      size              = data_disk.value["size"]
      # assign from scsi1 and up
      interface = "scsi${data_disk.key + 1}"
    }
  }
}
