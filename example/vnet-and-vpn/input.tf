variable "name" {
  type        = string
  default     = "fury"
  description = "Common project name"
}

variable "vnet_cidr" {
  type    = string
  default = "10.100.0.0/16"
}

variable "ssh_public_key" {
  type        = string
  default     = "/path/to/node-key.pub"
  description = "ssh public key to connect to bastion and nodes"
}

variable "ssh_private_key" {
  type        = string
  default     = "/path/to/node-key"
  description = "ssh private key to connect to bastion and nodes"
}

variable "tags" {
  type    = map(any)
  default = {}
}
