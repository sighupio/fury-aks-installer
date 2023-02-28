# data "external" "os" {
#   program = ["${path.module}/bin/os.sh"]
# }

locals {
  # os              = data.external.os.result.os
  # local_furyagent = local.os == "Darwin" ? "${path.module}/bin/furyagent-darwin-amd64" : "${path.module}/bin/furyagent-linux-amd64"

  vpntemplate_vars = {
    openvpn_port           = var.openvpn_port,
    openvpn_subnet_network = cidrhost(var.vnet_cidr[0], 0),
    openvpn_subnet_netmask = cidrnetmask(var.vnet_cidr[0]),
    openvpn_routes         = [{ "network" : cidrhost(var.vnet_cidr[0], 0), "netmask" : cidrnetmask(var.vnet_cidr[0]) }],
    openvpn_dhparam_bits   = var.vpn_dhparams_bits,
    furyagent_version      = "v0.2.2"
    furyagent              = indent(6, local_file.furyagent.content),
  }

  furyagent_vars = {
    servers = ["0.0.0.0"] // to be replased by the public ip of the vpn module.bastion.public_ip_address
    user    = var.vpn_operator_name,
  }
  furyagent = templatefile("${path.module}/templates/furyagent.yml", local.furyagent_vars)
  users     = var.vpn_ssh_users
  sshkeys_vars = {
    users = local.users
  }
  sshkeys = templatefile("${path.module}/templates/ssh-users.yml", local.sshkeys_vars)
}


resource "local_file" "furyagent" {
  content  = local.furyagent
  filename = "${path.root}/secrets/furyagent.yml"
}

resource "local_file" "sshkeys" {
  content  = local.sshkeys
  filename = "${path.root}/ssh-users.yml"
}

# resource "null_resource" "init" {
#   triggers = {
#     "init" : "just-once",
#   }
#   provisioner "local-exec" {
#     command = "until `${local.local_furyagent} init openvpn --config ${local_file.furyagent.filename}`; do echo \"Retrying\"; sleep 30; done" # Required because of aws iam lag
#   }
# }

# resource "null_resource" "ssh_users" {
#   triggers = {
#     "sync-users" : join(",", local.users),
#     "sync-operator" : var.vpn_operator_name
#   }
#   provisioner "local-exec" {
#     command = "until `${local.local_furyagent} init ssh-keys --config ${local_file.furyagent.filename}`; do echo \"Retrying\"; sleep 30; done" # Required because of aws iam lag
#   }
# }