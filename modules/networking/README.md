<!-- BEGIN_TF_DOCS -->

# Fury EKS Installer - vpc-and-vpn module

<!-- <KFD-DOCS> -->

## Requirements

| Name | Version |
|------|---------|
| terraform | = 0.15.4 |
| azurerm | 3.44.1 |
| external | 2.0.0 |
| local | 2.0.0 |
| null | 3.0.0 |
| template | 2.2.0 |

## Providers

| Name | Version |
|------|---------|
| azurerm | 3.44.1 |
| local | 2.0.0 |
| template | 2.2.0 |

## Inputs

| Name | Description | Default | Required |
|------|-------------|---------|:--------:|
| container\_name | The name of the container in which to create the blob. | n/a | yes |
| environment | This variable defines the environment to be built | `"development"` | no |
| key | The name of the blob in which to store the state. | n/a | yes |
| location | Azure region where the resource group will be created | `"westeurope"` | no |
| name | This variable defines the name of the company | `"fury"` | no |
| openvpn\_port | OpenVPN port | `1194` | no |
| resource\_group\_name | The name of the resource group in which to create the resources. | n/a | yes |
| ssh\_public\_key | SSH public key | `"~/.ssh/id_rsa.pub"` | no |
| storage\_account\_name | The name of the storage account in which to create the container. | n/a | yes |
| vnet\_cidr | n/a | ```[ "10.100.0.0/16" ]``` | no |
| vpn\_dhparams\_bits | Diffie-Hellman (D-H) key size in bytes | `2048` | no |
| vpn\_operator\_name | VPN operator name. Used to log into the instance via SSH | `"sighup"` | no |
| vpn\_ssh\_users | GitHub users id to sync public rsa keys. Example angelbarrera92 | ```[ "smerlos" ]``` | no |

## Outputs

| Name | Description |
|------|-------------|
| public\_ip\_address | n/a |


<!-- </KFD-DOCS> -->
<!-- END_TF_DOCS -->