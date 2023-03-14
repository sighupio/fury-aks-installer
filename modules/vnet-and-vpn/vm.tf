module "os" {
  source       = "./os"
  vm_os_simple = var.vpn_os
}
resource "random_id" "vpn-sa" {
  keepers = {
    vm_hostname = "${var.name}-bastion"
  }
  byte_length = 6
}
resource "azurerm_storage_account" "vpn-sa" {
  count                    = var.boot_diagnostics ? 1 : 0
  name                     = "bootdiag${lower(random_id.vpn-sa.hex)}"
  resource_group_name      = azurerm_resource_group.network_rg.name
  location                 = azurerm_resource_group.network_rg.location
  account_tier             = element(split("_", var.boot_diagnostics_sa_type), 0)
  account_replication_type = element(split("_", var.boot_diagnostics_sa_type), 1)
  tags                     = var.tags
}
resource "azurerm_virtual_machine" "vpn-vm-linux" {
  name                             = "${var.name}-bastion"
  resource_group_name              = azurerm_resource_group.network_rg.name
  location                         = azurerm_resource_group.network_rg.location
  availability_set_id              = azurerm_availability_set.vm.id
  vm_size                          = var.vm_size
  network_interface_ids            = [azurerm_network_interface.vpn.id]
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = false
  storage_image_reference {
    offer     = "UbuntuServer"
    publisher = "Canonical"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name                      = "osdisk-${var.name}-bastion"
    caching                   = "ReadWrite"
    create_option             = "FromImage"
    disk_size_gb              = 30
    managed_disk_type         = "Premium_LRS"
    os_type                   = "Linux"
    write_accelerator_enabled = false
  }
  os_profile {
    computer_name  = "${var.name}-bastion"
    admin_username = var.admin_username
    custom_data    = templatefile("${path.module}/templates/vpn.yml", local.vpntemplate_vars)
  }
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      key_data = file(var.ssh_key)
      path     = "/home/${var.admin_username}/.ssh/authorized_keys"
    }
  }
  tags = {
    environment = var.environment
    name        = var.name
  }

}
resource "azurerm_availability_set" "vm" {
  name                         = "${var.name}-avset"
  resource_group_name          = azurerm_resource_group.network_rg.name
  location                     = azurerm_resource_group.network_rg.location
  platform_fault_domain_count  = 2
  platform_update_domain_count = 2
  managed                      = true
  tags = {
    environment = var.environment
    name        = var.name
  }
}
resource "azurerm_public_ip" "vpn" {
  name                = "${var.name}-pip"
  resource_group_name = azurerm_resource_group.network_rg.name
  location            = azurerm_resource_group.network_rg.location
  allocation_method   = "Static"
  sku                 = "Basic"
  tags = {
    environment = var.environment
    name        = var.name
  }
}
resource "azurerm_network_security_group" "vpn" {
  name                = "${var.name}-nsg"
  resource_group_name = azurerm_resource_group.network_rg.name
  location            = azurerm_resource_group.network_rg.location
  tags = {
    environment = var.environment
    name        = var.name
  }
}
resource "azurerm_network_security_rule" "vpn" {
  count                       = var.remote_port != "" ? 1 : 0
  name                        = "allow_remote_${coalesce(var.remote_port, module.os.calculated_remote_port)}_in_all"
  resource_group_name         = azurerm_resource_group.network_rg.name
  description                 = "Allow remote protocol in from all locations"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = coalesce(var.remote_port, module.os.calculated_remote_port)
  source_address_prefixes     = var.source_address_prefixes
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.vpn.name
}
resource "azurerm_network_security_rule" "open-vpn" {
  name                        = "allow_remote_1194_in_all"
  resource_group_name         = azurerm_resource_group.network_rg.name
  description                 = "Allow remote protocol in from all locations"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = 1194
  source_address_prefixes     = var.source_address_prefixes
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.vpn.name
}
resource "azurerm_network_interface" "vpn" {
  name                          = "${var.name}-nic"
  resource_group_name           = azurerm_resource_group.network_rg.name
  location                      = azurerm_resource_group.network_rg.location
  enable_accelerated_networking = false
  ip_configuration {
    name                          = "${var.name}-ip"
    subnet_id                     = module.network.vnet_subnets[0]
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vpn.id
  }
  tags = {
    environment = var.environment
    name        = var.name
  }
  depends_on = [
    module.network.vnet_subnets
  ]
}
resource "azurerm_network_interface_security_group_association" "vpn" {
  network_interface_id      = azurerm_network_interface.vpn.id
  network_security_group_id = azurerm_network_security_group.vpn.id
}