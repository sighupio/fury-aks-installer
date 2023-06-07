<!-- BEGIN_TF_DOCS -->

# Fury AKS Installer - state module

<!-- <KFD-DOCS> -->

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.3 |
| azure cli | >= 2.48.1 |

## Providers

| Name | Version |
|------|---------|
| azurerm | ~> 3.44 |
| local | ~> 2.0.0 |

## Inputs

| Name | Description | Default | Required |
|------|-------------|---------|:--------:|
| company | This variable defines the name of the company | `"fury"` | no |
| environment | This variable defines the environment to be built | `"development"` | no |
| location | Azure region where the resource group will be created | `"westeurope"` | no |

## Outputs

| Name | Description |
|------|-------------|
| terraform\_state\_resource\_group\_name | Define an output to show the name of the resource group for the Terraform state file |
| terraform\_state\_storage\_account | Define an output to show the name of the storage account for the Terraform state file |
| terraform\_state\_storage\_container\_core | Define an output to show the name of the storage container for the core state file |


<!-- </KFD-DOCS> -->
<!-- END_TF_DOCS -->