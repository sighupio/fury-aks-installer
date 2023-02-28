resource "azurerm_network_security_rule" "bastion_openvpn" {
  name                        = "${lower(var.name)}-${lower(var.environment)}-openvpn-tcp"
  priority                    = 103
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = var.openvpn_port
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.network_rg.name
  network_security_group_name = module.bastion.network_security_group_name
  depends_on = [
    azurerm_resource_group.network_rg, module.network, module.bastion
  ]
}
resource "azurerm_network_security_rule" "ssh_tcp" {
  name                        = "${lower(var.name)}-${lower(var.environment)}-ssh-tcp"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.network_rg.name
  network_security_group_name = module.bastion.network_security_group_name
  depends_on = [
    azurerm_resource_group.network_rg, module.network, module.bastion
  ]
}