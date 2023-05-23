variable "network" {
  type = string
  default = "aks-installer"
}

variable "subnetworks" {
  type = list(string)
  default = ["aks-installer-aks"]
}

variable "resource_group_name" {
  type = string
  default = "aks-installer-aks-rg"
}

variable "location" {
  type = string
  default = "westeurope"
}
