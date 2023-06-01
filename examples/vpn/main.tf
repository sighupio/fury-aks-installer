provider "azurerm" {
  features {
  }
}

module "my-vpn" {
  source                         = "../../modules/vpn"
  name                           = var.name
  virtual_network_resource_group = var.virtual_network_resource_group
  virtual_network_name           = var.virtual_network_name
  subnet_name                    = var.subnet_name
  tags                           = var.tags
}
