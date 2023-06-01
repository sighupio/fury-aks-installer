resource "azurerm_resource_group" "network_rg" {
  name     = "${lower(var.name)}-network-rg"
  location = var.location

  # If you want to prevent the resource group from being destroyed, uncomment the following lifecycle block.
  # lifecycle {
  #   prevent_destroy = true
  # }

  tags = var.tags
}
