variable "virtual_network_resource_group" {
  description = "Name of the resource group where the Virtual Network is located"
  type        = string
}
variable "virtual_network_name" {
  description = "Name of the Virtual Network where nodes will be located"
  type        = string
}
variable "subnet_name" {
  description = "Name of the Subnet where nodes will be located"
  type        = string
}
variable "name" {
  description = "Name of the resources. Used as cluster name"
  type        = string
}
variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
variable "vpn_subnetwork_cidr" {
  description = "VPN Subnet CIDR, should be different from the network_cidr"
  type        = string
  default     = "192.168.200.0/24"
}
variable "vpn_port" {
  description = "VPN Server Port"
  type        = number
  default     = 1194
}
variable "vpn_operator_name" {
  description = "VPN operator name. Used to log into the instance via SSH"
  type        = string
  default     = "sighup"
}
variable "vpn_dhparams_bits" {
  description = "Diffie-Hellman (D-H) key size in bytes"
  type        = number
  default     = 2048
}
variable "vpn_ssh_users" {
  description = "GitHub users id to sync public rsa keys. Example angelbarrera92"
  type        = list(string)
  default     = []
}
variable "ssh_key" {
  description = "SSH public key file path for the virtual machine"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
  validation {
    condition     = fileexists(var.ssh_key)
    error_message = "The specified SSH public key file does not exist."
  }
}
variable "remote_port" {
  description = "Remote tcp port to be used for access to the vms created via the nsg applied to the nics."
  type        = string
  default     = "22"
}
variable "admin_username" {
  description = "The admin username of the VM that will be deployed."
  type        = string
  default     = "azureuser"
}
variable "vm_size" {
  description = "Specifies the size of the virtual machine."
  type        = string
  default     = "Standard_B2s"
}
variable "boot_diagnostics" {
  type        = bool
  description = "(Optional) Enable or Disable boot diagnostics."
  default     = false
}
variable "boot_diagnostics_sa_type" {
  description = "(Optional) Storage account type for boot diagnostics."
  type        = string
  default     = "Standard_LRS"
}
variable "source_address_prefixes" {
  description = "(Optional) List of source address prefixes allowed to access var.remote_port."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "vpn_bastions" {
  type        = number
  description = "Number of bastions to be deployed"
  default     = 2
}
