terraform {
  required_version = ">= 1.3"
  required_providers {
    azurerm  = "~> 3.44"
    external = "~> 2.3"
    local    = "~> 2.4"
    null     = "~> 3.2"
    random   = "~> 3.5"
  }
}

provider "azurerm" {
  # Configuration options
  features {}
}
