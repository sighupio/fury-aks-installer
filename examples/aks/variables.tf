variable "network" {
  type = string
}

variable "subnetworks" {
  type = list(string)
}

variable "resource_group_name" {
  type = string
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key to use for the cluster nodes"
}
