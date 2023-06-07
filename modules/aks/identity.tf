resource "azurerm_user_assigned_identity" "aks" {
  name                = var.cluster_name
  resource_group_name = var.resource_group_name
  location            = var.location
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
  principal_id       = azurerm_user_assigned_identity.aks.principal_id

  depends_on = [azurerm_role_definition.aks]
}

resource "azurerm_role_assignment" "aks_network" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.aks.principal_id
}
