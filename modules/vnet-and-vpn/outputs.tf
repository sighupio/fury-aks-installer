# Specifies the outputs of the Terraform configuration file.
# 
# The VPN instance IP is retrieved from the azurerm_public_ip resource using the [*].ip_address syntax to return a list of IP addresses.
#
# The ID of the Vnet is retrieved from the network module using the vnet_id variable.
#
# The CIDR block of the Vnet is retrieved from the network module using the vnet_address_space variable.
#
# The list of IDs of public subnets is retrieved from the network module using the vnet_subnets variable.

output "vpn_ip" {
  description = "VPN instance IP"
  value       = azurerm_public_ip.vpn[*].ip_address
}

output "vnet_id" {
  description = "The ID of the Vnet"
  value       = module.network.vnet_id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the Vnet"
  value       = module.network.vnet_address_space
}

output "subnets_ids" {
  description = "List of IDs of public subnets"
  value       = module.network.vnet_subnets
}
