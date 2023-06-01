<!-- BEGIN_TF_DOCS -->

# Fury AKS Installer - vnet module

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
| enforce\_private\_link | Enable or Disable enforcing private link connections | true | no |
| location | Azure region where the resource group will be created | `westeurope` | no |
| name | Name of the project. Used in multiple resources | n/a | yes |
| tags | The tags to apply to all resources | `{}` | no |
| vnet\_cidr | The CIDR block for the Virtual Network | `10.100.0.0/16` | no |

## Outputs

| Name | Description |
|------|-------------|
| subnets | The subnet IDs |
| vnet\_cidr | The CIDR block for the Virtual Network |
| vnet\_name | Name of the Virtual Network |

## Usage

```hcl
provider "azurerm" {
  features {
  }
}

module "my-vnet" {
  source    = "../../modules/vnet"
  name      = "fury"
  tags      = {}
}


```

<!-- </KFD-DOCS> -->
<!-- END_TF_DOCS -->
