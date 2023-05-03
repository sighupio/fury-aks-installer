terraform {
  required_version = ">=1.3.0"
  required_providers {
    kubernetes = "~>1.13.4"
    azuread    = "~>1.5.1"
    azurerm    = "~>2.60.0"
    random     = "~>3.1.3"
    null       = "~>3.1.1"
  }
}
