terraform {
  experiments      = [module_variable_optional_attrs]
  required_version = "0.15.4"
  required_providers {
    kubernetes = "1.13.3"
    azuread    = "1.5.0"
    azurerm    = "2.60.0"
    random     = "3.1.0"
    null       = "3.1.0"
  }
}
