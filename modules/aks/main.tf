terraform {
  required_version = ">= 1.3"
  required_providers {
    kubernetes = "~> 1.13"
    azuread    = "~> 1.6"
    azurerm    = "~> 2.99"
    random     = "~> 3.5"
    null       = "~> 3.2"
  }
}
