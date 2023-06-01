<!-- BEGIN_TF_DOCS -->

# Fury AKS Installer - vpn module

<!-- <KFD-DOCS> -->

## Requirements

| Name      | Version   |
|-----------|-----------|
| terraform | `>= 1.3.0` |

## Providers

| Name    | Version   |
|---------|-----------|
|azurerm  | `~> 3.44` |
|local    | `~> 2.0.0`|
|null     | `~> 3.2.1`|
|external | `~> 2.0.0`|
|template | `~> 2.2.0`|
|random   | `~> 3.4.3`|

## Inputs

| Name | Description | Default | Required |
|------|-------------|---------|:--------:|
| virtual\_network\_resource\_group | Name of the resource group where the Virtual Network is located | n/a | yes
| virtual\_network\_name | Name of the Virtual Network where nodes will be located | n/a | yes
| subnet\_name | Name of the Subnet where nodes will be located | n/a | yes
| name | Name of the project. Used in multiple resources | n/a | yes |
| tags | A map of tags to add to all resources | `{}` | no
| vpn\subnetwork_cidr | VPN Subnet CIDR, should be different from the network_cidr | `192.168.200.0/24` | no
| vpn\_port | VPN Server Port | `1194` | no
| vpn\_operator\_name | VPN operator name. Used to log into the instance via SSH | `sighup` | no
| vpn\_dhparams\_bits | Diffie-Hellman (D-H) key size in bytes | `2048` | no
| vpn\_ssh\_users | GitHub users id to sync public rsa keys | `[]` | no
| ssh\_key | SSH public key file path for the virtual machine | `~/.ssh/id_rsa.pub` | no
| remote\_port | Remote tcp port to be used for access to the vms created via the nsg applied to the nics | `22` | no
| admin\_username | The admin username of the VM that will be deployed | `azureuser` | no
| vm\_size | Specifies the size of the virtual machine | `Standard_B2s` | no
| boot\_diagnostics | Enable or Disable boot diagnostics | `false` | no
| boot\_diagnostics\_sa\_type | Storage account type for boot diagnostics | `Standard_LRS` | no
| source\_address\_prefixes | List of source address prefixes allowed to access `var.remote_port` | `0.0.0.0/0` | no
| vpn\_bastions | Number of bastions to be deployed | `2` | no

## Usage

```hcl
provider "azurerm" {
  features {
  }
}

module "my-vpn" {
  source    = "../../modules/vpn"
  name = "fury"
  virtual_network_resource_group = "fury-network-rg"
  virtual_network_name = "fury"
  subnet_name = "fury-bastion"
  tags = {}
}


```

<!-- </KFD-DOCS> -->
<!-- END_TF_DOCS -->
