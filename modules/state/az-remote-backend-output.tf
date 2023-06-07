# Define an output to show the name of the resource group for the Terraform state file
output "terraform_state_resource_group_name" {
  value = azurerm_resource_group.state_rg.name
}

# Define an output to show the name of the storage account for the Terraform state file
output "terraform_state_storage_account" {
  value = azurerm_storage_account.state_sta.name
}

# Define an output to show the name of the storage container for the core state file
output "terraform_state_storage_container_core" {
  value = azurerm_storage_container.core_container.name
}

locals {
  provider_configuration = <<EOF
  terraform {
    required_version = ">= 1.3"
    backend "azurerm" {
      resource_group_name  = ${azurerm_resource_group.state_rg.name}
      storage_account_name = ${azurerm_storage_account.state_sta.name}
      container_name       = ${azurerm_storage_container.core_container.name}
      key                  = ${azurerm_storage_account.state_sta.name}-core.tfstate
    }
  }
  EOF
  variable_files = <<EOF
  resource_group_name = ${azurerm_resource_group.state_rg.name}
  storage_account_name = ${azurerm_storage_account.state_sta.name}
  container_name = ${azurerm_storage_container.core_container.name}
  key = ${azurerm_storage_account.state_sta.name}-core.tfstate
  EOF
}
