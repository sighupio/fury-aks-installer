variable "vnet_cidr" {
  type        = string
  description = "The CIDR block for the VPC network"
  default     = "10.100.0.0/16"
}
# Azure location variable
variable "location" {
  type        = string
  description = "Azure region where the resource group will be created"
  default     = "westeurope"
}
variable "name" {
  description = "Name of the resources. Used as cluster name"
  type        = string
}
variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
variable "enforce_private_link" {
  type        = bool
  description = "(Optional) Enable or Disable enforcing private link connections."
  default     = true
}
