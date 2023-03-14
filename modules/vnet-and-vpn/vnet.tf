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

# module "network" {
#   source  = "Azure/network/azurerm"
#   version = "3.5.0"

#   vnet_name     = var.name
#   address_space = var.network_cidr

#   dns_servers         = []
#   resource_group_name = var.resource_group_name
#   subnet_names        = var.subnetwork_names
#   subnet_prefixes     = var.subnetwork_cidrs
#   tags                = var.tags

#   subnet_enforce_private_link_endpoint_network_policies = {
#     "${var.name}-aks" : true
#   }

#   #subnet_service_endpoints = ["Microsoft.Storage"]
# }



#resource "azurerm_network_security_group" "subnet" {
#  count               = length(var.subnetwork_names)
#  name                = "${var.subnetwork_names[count.index]}-nsg"
#  resource_group_name = data.azurerm_resource_group.network.name
#  location            = coalesce(var.location, data.azurerm_resource_group.network.location)
#
#  tags = var.tags
#}

# resource "azurerm_subnet_network_security_group_association" "subnet" {
#   count                     = length(var.subnetwork_names)
#   subnet_id                 = module.network.vnet_subnets[count.index]
#   network_security_group_id = azurerm_network_security_group.subnet[count.index].id
# }