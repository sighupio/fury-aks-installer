# Network

module "network" {
  source  = "Azure/network/azurerm"
  version = "3.5.0"

  vnet_name           = "${var.name}"
  address_space       = var.vnet_cidr
  dns_servers         = []
  resource_group_name = data.azurerm_resource_group.fury.name
  subnet_names        = ["${var.name}-bastion", "${var.name}-aks"]
  subnet_prefixes     = [cidrsubnet(var.vnet_cidr, 1, 0), cidrsubnet(var.vnet_cidr, 1, 1)]
  tags                = {}

  subnet_enforce_private_link_endpoint_network_policies = {
    "${var.name}-aks" : true
  }
}

# Bastion

module "bastion" {

  source  = "Azure/compute/azurerm"
  version = "3.14.0"

  allocation_method             = "Static"
  boot_diagnostics              = false
  delete_os_disk_on_termination = true
  enable_ssh_key                = true
  nb_data_disk                  = 0
  nb_instances                  = 1
  nb_public_ip                  = 1
  remote_port                   = "65535"
  resource_group_name           = data.azurerm_resource_group.fury-poc.name
  ssh_key                       = var.ssh_public_key
  vm_hostname                   = "${var.name}-bastion"
  vm_os_offer                   = "UbuntuServer"
  vm_os_publisher               = "Canonical"
  vm_os_sku                     = "18.04-LTS"
  vm_size                       = "Standard_B2s"
  vnet_subnet_id                = module.network.vnet_subnets[0]
}

resource "azurerm_network_security_rule" "bastion_openvpn_tcp" {
  name                        = "bastion-openvpn-tcp"
  priority                    = 102
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "1194"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.fury.name
  network_security_group_name = module.bastion.network_security_group_name
}

resource "azurerm_network_security_rule" "bastion_openvpn_udp" {
  name                        = "bastion-openvpn-udp"
  priority                    = 103
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Udp"
  source_port_range           = "*"
  destination_port_range      = "1194"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.fury.name
  network_security_group_name = module.bastion.network_security_group_name
}
