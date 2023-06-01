variable "name" {
  type        = string
  description = "Common project name"
}

variable "virtual_network_resource_group" {
  type = string
}

variable "virtual_network_name" {
  type = string
}

variable "subnet_name" {
  type = string
}

variable "tags" {
  type    = map(any)
}
