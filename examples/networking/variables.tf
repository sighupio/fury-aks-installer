variable "name" {
  type        = string
  description = "Common project name"
}

variable "vnet_cidr" {
  type    = string
}

variable "ssh_public_key_path" {
  type        = string
  description = "ssh public key to connect to bastion and nodes"
}

variable "tags" {
  type    = map(any)
  default = {}
}
