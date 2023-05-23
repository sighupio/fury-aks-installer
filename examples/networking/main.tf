provider "azurerm" {
  features {
  }
}

module "my-vnet" {
  source = "../../modules/vnet-and-vpn"
  name   = var.name
  ssh_key = var.ssh_public_key_path
  vnet_cidr = var.vnet_cidr
  tags = var.tags
}

output "vpn_ip" {
  value = module.my-vnet.vpn_ip
}
