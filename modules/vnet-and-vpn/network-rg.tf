# Creates an Azure Resource Group to store Terraform state files
#
# The resource group is named using the lowercased var.name variable and the location is set using the var.location variable.
#
# Tags are added to the resource group using the var.environment and var.name variables.
#
# The lifecycle block is currently commented out, which means that the resource group can be destroyed if it's no longer needed.

resource "azurerm_resource_group" "network_rg" {
  name     = "${lower(var.name)}-network-rg"
  location = var.location

  # If you want to prevent the resource group from being destroyed, uncomment the following lifecycle block.
  # lifecycle {
  #   prevent_destroy = true
  # }

  tags = var.tags
}
