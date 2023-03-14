# output "furyagent" {
#   description = "furyagent.yml used by the vpn instance and ready to use to create a vpn profile"
#   sensitive   = true
#   value       = local.furyagent
# }

output "vpn_ip" {
  description = "VPN instance IP"
  value       = azurerm_public_ip.vpn.*.ip_address
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
