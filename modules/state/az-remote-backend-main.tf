# Generate a random storage name
resource "random_string" "tf_name" {
  length  = 8
  upper   = false
  numeric = true
  lower   = true
  special = false
}

# Create a Resource Group for the Terraform State File
resource "azurerm_resource_group" "state_rg" {
  name     = "${lower(var.company)}-tfstate-rg"
  location = var.location

  # Set prevent_destroy to true to avoid accidental deletion of the resource group
  lifecycle {
    prevent_destroy = true
  }

  # Set a tag for the environment
  tags = {
    environment = var.environment
  }
}

# Create a Storage Account for the Terraform State File
resource "azurerm_storage_account" "state_sta" {
  depends_on = [azurerm_resource_group.state_rg]

  # Set the name of the storage account using the company name and a random string
  name                      = "${lower(var.company)}tf${random_string.tf_name.result}"
  resource_group_name       = azurerm_resource_group.state_rg.name
  location                  = azurerm_resource_group.state_rg.location
  account_kind              = "StorageV2"
  account_tier              = "Standard"
  access_tier               = "Hot"
  account_replication_type  = "ZRS"
  enable_https_traffic_only = true

  # Set prevent_destroy to true to avoid accidental deletion of the storage account
  lifecycle {
    prevent_destroy = true
  }

  # Set a tag for the environment
  tags = {
    environment = var.environment
  }
}

# Create a Storage Container for the Core State File
resource "azurerm_storage_container" "core_container" {
  depends_on = [azurerm_storage_account.state_sta]

  # Set the name of the storage container and the storage account it belongs to
  name                 = "core-tfstate"
  storage_account_name = azurerm_storage_account.state_sta.name
}
