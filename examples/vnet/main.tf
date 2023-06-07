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

module "my-vnet" {
  source    = "../../modules/vnet"
  name      = var.name
  vnet_cidr = var.vnet_cidr
  tags      = var.tags
}
