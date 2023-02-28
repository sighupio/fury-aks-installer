# Define an output to show the name of the resource group for the Terraform state file
output "terraform_state_resource_group_name" {
  value = azurerm_resource_group.state-rg.name
}

# Define an output to show the name of the storage account for the Terraform state file
output "terraform_state_storage_account" {
  value = azurerm_storage_account.state-sta.name
}

# Define an output to show the name of the storage container for the core state file
output "terraform_state_storage_container_core" {
  value = azurerm_storage_container.core-container.name
}