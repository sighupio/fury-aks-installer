terraform {
  required_version = "= 0.15.4"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.44.1"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.0.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {}
}