resource "azurerm_resource_group" "aks_rg" {
  name     = var.resource_group_name
  location = var.location

  # If you want to prevent the resource group from being destroyed, uncomment the following lifecycle block.
  # lifecycle {
  #   prevent_destroy = true
  # }

  tags = var.tags
}