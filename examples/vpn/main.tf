terraform {
  required_version = "~> 1.4.6"
  required_providers {
    azurerm = "~> 3.44.0"
    random  = "~> 3.5.1"
    null    = "~> 3.2.1"
    external = "~> 2.3.1"
    local    = "~> 2.4.0"
  }
}

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
