variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the resources."
}
variable "storage_account_name" {
  type        = string
  description = "The name of the storage account in which to create the container."
}
variable "container_name" {
  type        = string
  description = "The name of the container in which to create the blob."
}
variable "key" {
  type        = string
  description = "The name of the blob in which to store the state."
}

variable "name" {
  type        = string
  description = "This variable defines the name of the company"
  default     = "fury"
}

variable "environment" {
  type        = string
  description = "This variable defines the environment to be built"
  default     = "development"
}

# Azure location variable
variable "location" {
  type        = string
  description = "Azure region where the resource group will be created"

  # Default value set to "westeurope"
  default = "westeurope"
}

variable "vnet_cidr" {
  type    = list(string)
  default = ["10.100.0.0/16"]
}
variable "openvpn_port" {
  type        = number
  default     = 1194
  description = "OpenVPN port"
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key"
  default     = "~/.ssh/id_rsa.pub"
}
variable "vpn_ssh_users" {
  description = "GitHub users id to sync public rsa keys. Example angelbarrera92"
  type        = list(string)
  default     = ["smerlos"]
}
variable "vpn_dhparams_bits" {
  description = "Diffie-Hellman (D-H) key size in bytes"
  type        = number
  default     = 2048
}

variable "vpn_operator_name" {
  description = "VPN operator name. Used to log into the instance via SSH"
  type        = string
  default     = "sighup"
}