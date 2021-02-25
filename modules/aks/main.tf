terraform {
  required_version = ">= 0.12.0"
  required_providers {
    kubernetes = "= 1.13.3"
    azuread    = "= 1.4.0"
    azurerm    = "= 2.48.0"
    random     = "= 3.1.0"
    null       = "= 3.1.0"
  }
}
