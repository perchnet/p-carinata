virtual_environment_insecure = true # false
node_name = "pve1"
qcow2_datastore = "rust-files"
os_disk_datastore = "zssd"
os_disk_size_gb = 30
vm_memory_mb = 4096
vm_bridge = "vmbr0"
vm_username = "bri"
ssh_public_keys = [
  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPDx+KV/SW4RGIeKA2FHU9S7bZgnJMy77N6lBeo2n8sJ",
]