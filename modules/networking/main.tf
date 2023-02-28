terraform {
  required_version = "= 0.15.4"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.44.1"
    }
    local    = "2.0.0"
    null     = "3.0.0"
    external = "2.0.0"
    template = "2.2.0"
  }
  backend "azurerm" {
    resource_group_name  = var.resource_group_name
    storage_account_name = var.storage_account_name
    container_name       = var.container_name
    key                  = var.key
  }
}

provider "azurerm" {
  # Configuration options
  features {}
}
