variable "name" {
  type        = string
  description = "Common project name"
  default = "aks-installer"
}

variable "vnet_cidr" {
  type    = string
  default = "10.100.0.0/16"
}

variable "ssh_public_key_path" {
  type        = string
  description = "ssh public key to connect to bastion and nodes"
  default = "~/.ssh/id_rsa.pub"
}

variable "tags" {
  type    = map(any)
  default = {}
}
