terraform {
  required_version = ">= 0.12.0"
  required_providers {
    kubernetes = ">= 1.11.1"
    azuread    = ">=0.8"
    azurerm    = "2.5.0"
    random     = ">=2.2"
    null       = ">= 2.1"
  }
}
