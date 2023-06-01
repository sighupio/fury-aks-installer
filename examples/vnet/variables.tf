variable "name" {
  type        = string
  description = "Common project name"
}

variable "vnet_cidr" {
  type    = string
}

variable "tags" {
  type    = map(any)
}
