provider "azurerm" {
  features {
  }
}

module "my-vnet" {
  source    = "../../modules/vnet"
  name      = var.name
  vnet_cidr = var.vnet_cidr
  tags      = var.tags
}
