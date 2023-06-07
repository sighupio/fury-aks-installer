variable "virtual_network_resource_group" {
  type = string
}
variable "virtual_network_name" {
  type = string
}

variable "subnet_names" {
  type = list(string)
}

variable "cluster_name" {
  type = string
}

variable "cluster_version" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "ssh_public_key" {
  type = string
}
