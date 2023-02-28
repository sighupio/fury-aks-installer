terraform {
  required_version = "= 0.15.4"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.44.1"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {}
}