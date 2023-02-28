data "template_cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  # Main cloud-config configuration file.
  part {
    content_type = "text/cloud-config"
    content      = templatefile("${path.module}/templates/vpn.yml", local.vpntemplate_vars)
  }
}
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
  resource_group_name           = azurerm_resource_group.network_rg.name
  ssh_key                       = var.ssh_public_key
  vm_hostname                   = "${var.name}-bastion"
  vm_os_offer                   = "UbuntuServer"
  vm_os_publisher               = "Canonical"
  vm_os_sku                     = "18.04-LTS"
  vm_size                       = "Standard_B2s"
  vnet_subnet_id                = module.network.vnet_subnets[0]
  custom_data                   = data.template_cloudinit_config.config.rendered
  tags = {
    environment = var.environment
    name        = var.name
  }
  depends_on = [
    module.network, azurerm_resource_group.network_rg
  ]
}
