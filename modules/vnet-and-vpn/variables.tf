variable "environment" {
  type        = string
  description = "This variable defines the environment to be built"
  default     = "development"
}
variable "vnet_cidr" {
  type        = list(string)
  description = "The CIDR block for the VPC network"
  default     = ["10.100.0.0/16"]
}


# Azure location variable
variable "location" {
  type        = string
  description = "Azure region where the resource group will be created"
  # Default value set to "westeurope"
  default = "westeurope"
}

variable "name" {
  description = "Name of the resources. Used as cluster name"
  type        = string
  default     = "poc-fury"
}

variable "furyagent_storage_account_name" {
  description = "Furyagent Storage Account Name. Can only consist of lowercase letters and numbers, and must be between 3 and 24 characters long"
  type        = string
  default     = "furyagentstorage2"
}


variable "network_cidr" {
  description = "VPC Network CIDR"
  type        = string
  default     = "10.100.0.0/16"
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


variable "vpn_os" {
  description = "VPN Operative System"
  type        = string
  default     = "UbuntuServer"
}

variable "vpn_operator_name" {
  description = "VPN operator name. Used to log into the instance via SSH"
  type        = string
  default     = "sighup"
}

variable "vpn_dhparams_bits" {
  description = "Diffie–Hellman (D-H) key size in bytes"
  type        = number
  default     = 2048
}


variable "vpn_ssh_users" {
  description = "GitHub users id to sync public rsa keys. Example angelbarrera92"
  type        = list(string)
  default     = ["smerlos"]
}


# variable "ssh_key" {
#   description = "Path to the public key to be used for ssh access to the VM. Only used with non-Windows vms and can be left as-is even if using Windows vms. If specifying a path to a certification on a Windows machine to provision a linux vm use the / in the path versus backslash. e.g. c:/home/id_rsa.pub."
#   type        = string
#   default     = "~/.ssh/id_rsa.pub"
# }

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
