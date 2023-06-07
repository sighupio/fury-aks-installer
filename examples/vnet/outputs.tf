output "vnet_name" {
  value = module.my-vnet.vnet_name
}

output "vnet_cidr" {
  value = module.my-vnet.vnet_cidr
}

output "subnets" {
  value = module.my-vnet.subnets
}
