# Network

module "network" {
  source  = "Azure/network/azurerm"
  version = "3.5.0"

  vnet_name           = var.name
  address_space       = var.vnet_cidr[0]
  dns_servers         = []
  resource_group_name = azurerm_resource_group.network_rg.name
  subnet_names        = ["${var.name}-bastion", "${var.name}-aks"]
  subnet_prefixes     = [cidrsubnet(var.vnet_cidr[0], 1, 0), cidrsubnet(var.vnet_cidr[0], 1, 1)]
  tags = {
    environment = var.environment
    name        = var.name
  }

  subnet_enforce_private_link_endpoint_network_policies = {
    "${var.name}-aks" : true
  }

  depends_on = [
    azurerm_resource_group.network_rg
  ]
}