output "vnet_name" {
  value = module.network.vnet_name
}

output "vnet_cidr" {
  value = flatten(module.network.vnet_address_space)
}

output "subnets" {
  value = flatten(module.network.vnet_subnets)
}
