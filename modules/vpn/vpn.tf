data "external" "os" {
  program = ["${path.module}/bin/os.sh"]
}

locals {
  os              = data.external.os.result.os
  local_furyagent = local.os == "Darwin" ? "${path.module}/bin/furyagent-darwin-amd64" : "${path.module}/bin/furyagent-linux-amd64"

  vpntemplate_vars = {
    openvpn_port           = var.vpn_port,
    openvpn_subnet_network = cidrhost(var.vpn_subnetwork_cidr, 0),
    openvpn_subnet_netmask = cidrnetmask(var.vpn_subnetwork_cidr),
    openvpn_routes         = [{ "network" : cidrhost(data.azurerm_virtual_network.network.address_space[0], 0), "netmask" : cidrnetmask(data.azurerm_virtual_network.network.address_space[0]) }, { "network" : "168.63.129.16", "netmask" : "255.255.255.255" }],
    openvpn_dns_servers    = ["168.63.129.16"], # Azure Private DNS IP
    openvpn_dhparam_bits   = var.vpn_dhparams_bits,
    furyagent_version      = "v0.3.0"
    furyagent              = indent(6, local_file.furyagent.content),
  }

  furyagent_vars = {
    azure_storage_account = azurerm_storage_account.furyagent.name,
    azure_storage_key     = azurerm_storage_account.furyagent.primary_access_key,
    bucketName            = azurerm_storage_container.furyagent.name,
    servers               = [for serverIP in azurerm_public_ip.vpn[*].ip_address : "${serverIP}:${var.vpn_port}"]

    user = var.vpn_operator_name,
  }
  furyagent = templatefile("${path.module}/templates/furyagent.yml", local.furyagent_vars)
  users     = var.vpn_ssh_users
  sshkeys_vars = {
    users = local.users
  }
  sshkeys = templatefile("${path.module}/templates/ssh-users.yml", local.sshkeys_vars)
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
  resource_group_name         = data.azurerm_resource_group.network_rg.name
  network_security_group_name = azurerm_network_security_group.vpn.name
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
  resource_group_name         = data.azurerm_resource_group.network_rg.name
  network_security_group_name = azurerm_network_security_group.vpn.name
}
# Furyagent
resource "local_file" "furyagent" {
  content  = local.furyagent
  filename = "${path.root}/secrets/furyagent.yml"
}
resource "local_file" "sshkeys" {
  content  = local.sshkeys
  filename = "${path.root}/ssh-users.yml"
}
resource "null_resource" "init" {
  triggers = {
    "init" : "just-once",
  }
  provisioner "local-exec" {
    command = "until `${local.local_furyagent} init openvpn --config ${local_file.furyagent.filename}`; do echo \"Retrying\"; sleep 30; done"
  }
}
resource "null_resource" "ssh_users" {
  triggers = {
    "sync-users" : join(",", local.users),
    "sync-operator" : var.vpn_operator_name
  }
  provisioner "local-exec" {
    command = "until `${local.local_furyagent} init ssh-keys --config ${local_file.furyagent.filename}`; do echo \"Retrying\"; sleep 30; done"
  }
}
# Storage account
resource "azurerm_storage_account" "furyagent" {
  name                      = replace("${var.name}furyagent", "-", "")
  resource_group_name       = data.azurerm_resource_group.network_rg.name
  location                  = data.azurerm_resource_group.network_rg.location
  account_kind              = "BlobStorage"
  account_tier              = "Standard"
  account_replication_type  = "GRS"
  access_tier               = "Hot"
  enable_https_traffic_only = true
  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}
resource "azurerm_storage_container" "furyagent" {
  name                  = "furyagent"
  storage_account_name  = azurerm_storage_account.furyagent.name
  container_access_type = "private"
}
