resource "azuread_application" "aks" {
  name = var.cluster_name
}

resource "azuread_service_principal" "aks" {
  application_id = azuread_application.aks.application_id
}

resource "random_string" "aks" {
  length  = 16
  special = true

  keepers = {
    service_principal = azuread_service_principal.aks.id
  }
}

resource "azuread_service_principal_password" "aks" {
  service_principal_id = azuread_service_principal.aks.id
  value                = random_string.aks.result
  end_date             = timeadd(timestamp(), "8760h")

  # This stops be 'end_date' changing on each run and causing a new password to be set
  # to get the date to change here you would have to manually taint this resource...
  lifecycle {
    ignore_changes = [end_date]
  }
}

# Attempt to create a 'least privilidge' role for SP used by AKS
resource "azurerm_role_definition" "aks" {
  name        = var.cluster_name
  scope       = data.azurerm_subscription.current.id
  description = "This role provides the required permissions needed by Kubernetes to: Manager VMs, Routing rules, Mount azure files and Read container repositories"

  permissions {
    actions = [
      "Microsoft.Compute/virtualMachines/read",
      "Microsoft.Compute/virtualMachines/write",
      "Microsoft.Compute/disks/write",
      "Microsoft.Compute/disks/read",
      "Microsoft.Network/loadBalancers/write",
      "Microsoft.Network/loadBalancers/read",
      "Microsoft.Network/routeTables/read",
      "Microsoft.Network/routeTables/routes/read",
      "Microsoft.Network/routeTables/routes/write",
      "Microsoft.Network/routeTables/routes/delete",
      "Microsoft.Network/virtualNetworks/subnets/join/action",
      "Microsoft.Storage/storageAccounts/fileServices/*/read",
      "Microsoft.ContainerRegistry/registries/read",
      "Microsoft.ContainerRegistry/registries/pull/read",
      "Microsoft.Network/publicIPAddresses/read",
      "Microsoft.Network/publicIPAddresses/write",
    ]

    not_actions = [
      "Microsoft.Compute/virtualMachines/*/action",
      "Microsoft.Compute/virtualMachines/extensions/*",
    ]
  }

  assignable_scopes = [
    data.azurerm_subscription.current.id,
  ]
}

resource "azurerm_role_assignment" "aks_control_plane" {
  scope              = data.azurerm_subscription.current.id
  role_definition_id = trimsuffix(azurerm_role_definition.aks.id, "|${azurerm_role_definition.aks.scope}")
  principal_id       = azuread_service_principal.aks.id

  depends_on = [azurerm_role_definition.aks]
}

resource "azurerm_role_assignment" "aks_network" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Network Contributor"
  principal_id         = azuread_service_principal.aks.id
}
