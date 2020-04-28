data "azurerm_subscription" "current" {
}

data "azurerm_resource_group" "aks" {
  name = var.resource_group_name
}

data "azurerm_subnet" "subnetwork" {
  name                 = var.subnetworks[0]
  virtual_network_name = var.network
  resource_group_name  = var.resource_group_name
}
