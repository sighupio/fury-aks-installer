terraform {
  required_version = ">= 0.12.0"
  required_providers {
    kubernetes = ">= 1.13.2"
    azuread    = ">= 1.0.0"
    azurerm    = ">= 2.33.0"
    random     = ">= 3.0.0"
    null       = ">= 3.0.0"
  }
}
