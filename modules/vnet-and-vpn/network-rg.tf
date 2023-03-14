# Create a Resource Group for the Terraform State File
resource "azurerm_resource_group" "network_rg" {
  name     = "${lower(var.name)}-network-rg"
  location = var.location
  # lifecycle {
  #   prevent_destroy = true
  # }
  tags = {
    environment = var.environment
    name        = var.name
  }
}