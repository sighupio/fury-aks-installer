# Network
module "network" {
  source              = "Azure/network/azurerm"
  version             = "5.2.0"
  vnet_name           = var.name
  address_space       = var.vnet_cidr
  dns_servers         = []
  resource_group_name = azurerm_resource_group.network_rg.name
  subnet_names        = ["${var.name}-bastion", "${var.name}-aks"]
  subnet_prefixes     = [cidrsubnet(var.vnet_cidr, 1, 0), cidrsubnet(var.vnet_cidr, 1, 1)]
  tags                = var.tags
  subnet_enforce_private_link_endpoint_network_policies = {
    "${var.name}-aks" : var.enforce_private_link
  }
  depends_on = [
    azurerm_resource_group.network_rg
  ]
  use_for_each = false
}