terraform {
  required_version = ">= 1.3"
  required_providers {
    azurerm = "~> 3.44"
    local = "~> 2.4"
  }
}

provider "azurerm" {
  # Configuration options
  features {}
}
