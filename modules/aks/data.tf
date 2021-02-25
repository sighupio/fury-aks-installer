data "azurerm_subscription" "current" {
}

data "azurerm_resource_group" "aks" {
  name = var.resource_group_name
}
