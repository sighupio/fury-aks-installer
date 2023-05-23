provider "azurerm" {
  features {
  }
}

module "my-vnet" {
  source = "../../modules/vnet-and-vpn"
  name   = "aks-installer"
  tags = {
    "source" = "terraform"
  }
}

output "vpn_ip" {
  value = module.my-vnet.vpn_ip
}
