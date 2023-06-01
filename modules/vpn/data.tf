data "azurerm_resource_group" "network_rg" {
  name = var.virtual_network_resource_group
}

data "azurerm_virtual_network" "network" {
  name = var.virtual_network_name
  resource_group_name = var.virtual_network_resource_group
}

data "azurerm_subnet" "bastion_subnet" {
  name = var.subnet_name
  virtual_network_name = var.virtual_network_name
  resource_group_name = var.virtual_network_resource_group
}