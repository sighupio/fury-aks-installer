data "azurerm_subscription" "current" {
}

data "azurerm_resource_group" "network" {
  name = var.network_resource_group_name
}
