variable "carinata_cloud_image_url" {
  description = "URL to download the Carinata cloud image from"
  type = string
  default = "https://github.com/perchnet/p-carinata/releases/download/rolling/p-carinata-amd64.qcow2"
}
###### PVE API Access ######
variable "virtual_environment_api_token" {
  description = "API token for proxmox"
  type        = string
}
variable "virtual_environment_endpoint" {
  description = "API endpoint for proxmox"
  type        = string
}
variable "virtual_environment_insecure" {
  description = "Skip validating TLS certificate chain"
  type        = bool
  default     = null
}
variable "virtual_environment_ssh_username" {
  description = "SSH username for Proxmox commands that require SSH"
  default     = "root"
  type        = string
}
variable "virtual_environment_ssh_agent" {
  description = "Enable SSH agent authentication"
  type        = bool
  default     = false
}

variable "node_name" {
  description = "Proxmox node name to create VMs on"
  type        = string
  default     = "pve"
}


###### Naming ######
variable "template_name" {
  description = "Name for the VM template"
  type        = string
  default     = "template.carinata"
}

variable "template_description" {
  description = "Description for the VM template"
  type        = string
  default     = <<-EOT
  # Template for [Carinata](https://github.com/tulilirockz/carinata) VMs
  EOT
}

variable "vm_name" {
  description = "Base name used for created VMs"
  type        = string
  default     = "p-carinata"
}

variable "vm_description" {
  description = "VM description"
  type = string
  default = <<-EOT
  # Carinata VM
  EOT
}

###### Disks and storage ######
variable "datastore" {
  description = "Datastore for all disks that aren't explicitly defined"
  default = "local-zfs"
  type = string
}

variable "cloudinit_datastore" {
  description = "Datastore for the cloud-init disk"
  default = null
}

variable "qcow2_datastore" {
  description = "Datastore to download qcow2 image to"
  default = null
}
variable "os_disk_datastore" {
  description = "Datastore to import the OS disk onto"
  type        = string
  default     = null
}

variable "os_disk_size_gb" {
  description = "What to resize the OS disk to after import (in GB)"
  default = null
  type = number
}

variable "data_vm_disks" {
  description = "List of disks for the data VM. Each item may include an optional `datastore_id` (string) and a required `size` (GB number). If `datastore_id` is omitted or null the `datastore` value is used."
  type = list(object({
    datastore_id = optional(string)
    size         = number
  }))
  default = [] # default to no separate disks
}

###### VM Settings ######

variable "firmware" {
  description = "Firmware for the VM"
  type        = string
  default     = "bios"
}

variable "vm_clone_full" {
  description = "Perform a linked clone of the VM template instead of a full clone. Not recommended, because the template cannot be deleted or replaced while linked clones exist."
  type        = bool
  default     = true
}

variable "vm_qemu_agent_enabled" {
  description = "Enable the QEMU guest agent on created VMs"
  type        = bool
  default     = true
}

variable "vm_stop_on_destroy" {
  description = "Optional: stop the VM on destroy. If null the value falls back to `vm_qemu_agent_enabled`, as this is only relevant when the QEMU agent is enabled."
  type        = any
  default     = null
}

variable "vm_memory_mb" {
  description = "Default memory (in MB) for created VMs"
  type        = number
  default     = 768
}

variable "vm_bridge" {
  description = "Default bridge to attach VM NICs to"
  type        = string
  default     = "vmbr0"
}

###### Data VM Settings ######

variable "data_vm_node_name" {
  description = "Optional node name for the data VM; falls back to `node_name` when empty"
  type        = string
  default     = null
}

variable "data_vm_name" {
  description = "Optional name for the data VM; falls back to a derivative of `vm_name` when empty"
  type        = string
  default     = null
}

variable "data_vm_disks_datastore" {
  description = "Default datastore for data VM disks when individual disk entries omit a datastore_id"
  type        = string
  default     = null
}

variable "ssh_public_keys" {
  description = "List of SSH public keys to inject via cloud-init"
  type        = list(string)
  default     = []
}

variable "vm_username" {
  description = "Default username to create via cloud-init"
  type        = string
  default     = "carainata"
}

variable "vm_password" {
  description = "Optional password to set via cloud-init (use null to avoid setting a password)"
  type        = string
  default     = null
}

variable "vm_ipv4_address" {
  description = "IPv4 address to configure for the VM; use \"dhcp\" to obtain an address via DHCP"
  type        = string
  default     = "dhcp"
}

variable "vm_ipv4_gateway" {
  description = "Optional IPv4 gateway to configure for the VM"
  type        = string
  default     = null
}

variable "canary" {
  description = "Not used for anything, but changing this value replaces the image and VM."
  type        = string
  default     = "v1"
}