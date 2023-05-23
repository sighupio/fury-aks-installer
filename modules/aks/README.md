<!-- BEGIN_TF_DOCS -->

# Fury AKS Installer - aks module

<!-- <KFD-DOCS> -->

## Requirements

| Name | Version |
|------|---------|
| terraform | `>=1.3.0` |

## Providers

| Name | Version |
|------|--------|
|azurerm    | `~>3.44.1`|
|random     | `~>3.5`|
|null       | `~>3.2`|

## Inputs

| Name | Description | Default | Required |
|------|-------------|---------|:--------:|
| admin\_group\_object\_ids | Users or groups to be enabled as admins | `[]` | no |
| cluster\_name | Unique cluster name. Used in multiple resources to identify your cluster resources | n/a | yes |
| cluster\_version | Kubernetes Cluster Version. Look at the cloud providers documentation to discover available versions. EKS example -> 1.25, GKE example -> 1.25.7-gke.1000 | n/a | yes |
| dmz\_cidr\_range | Network CIDR range from where cluster control plane will be accessible | n/a | yes |
| location | Resource group location. Required only in AKS installer (*) | n/a | yes |
| network | Network where the Kubernetes cluster will be hosted | n/a | yes |
| network\_resource\_group\_name | Network resource group where the Network is located. Required only in AKS installer (*) | n/a | yes |
| node\_pools | An object list defining node pools configurations | `[]` | no |
| resource\_group\_name | Resource group name where every resource will be placed. Required only in AKS installer (*) | n/a | yes |
| ssh\_public\_key | Cluster administrator public ssh key. Used to access cluster nodes with the operator\_ssh\_user | n/a | yes |
| subnetworks | List of subnets where the cluster will be hosted | n/a | yes |
| tags | The tags to apply to all resources | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| kubeconfig\_admin | The raw kubeconfig for admin user. Ready to be exported to file. |
| kubeconfig | The raw kubeconfig for any user. Ready to be exported to file. |
| cluster\_certificate\_authority | The base64 encoded certificate data required to communicate with your cluster. Add this to the certificate-authority-data section of the kubeconfig file for your cluster |
| cluster\_endpoint | The endpoint for your Kubernetes API server |
| operator\_ssh\_user | SSH user to access cluster nodes with ssh\_public\_key |

## Usage

```hcl
provider "azurerm" {
  features {
  }
}

data "azurerm_resource_group" "network" {
  name = "my-network-rg"
}

module "my_cluster" {
  source = "../../modules/aks"

  cluster_version     = "1.25.6"
  cluster_name        = "aks-installer"
  network_resource_group_name = data.azurerm_resource_group.network.name
  network             = "aks-installer-local"
  subnetworks         = ["aks-installer-local-main"]
  ssh_public_key      = "ssh-rsa my-public-key"
  dmz_cidr_range      = "11.11.0.0/16"
  resource_group_name = "aks-installer"
  location = "westeurope"
  tags                = {}
  node_pools = [
    {
      name : "nodepool1"
      version : null
      min_size : 1
      max_size : 1
      instance_type : "Standard_DS2_v2"
      volume_size : 100
      labels : {
        "sighup.io/role" : "app"
        "sighup.io/fury-release" : "v1.3.0"
      }
      taints : []
      tags : {}
      # max_pods : null
    },
    {
      name : "nodepool2"
      version : null
      min_size : 1
      max_size : 1
      instance_type : "Standard_DS2_v2"
      volume_size : 50
      labels : {}
      taints : [
        "sighup.io/role=app:NoSchedule",
      ]
      tags : {}
      max_pods : 50
    }
  ]
}

data "azurerm_client_config" "current" {

}

data "azurerm_subscription" "current" {

}

# This gives the connected user the admin role on the cluster (it's not the admin kubeconfig)
resource "azurerm_role_assignment" "aks-admin" {
  role_definition_name = "Azure Kubernetes Service RBAC Cluster Admin"
  principal_id = data.azurerm_client_config.current.object_id
  scope = data.azurerm_subscription.current.id
}

```

<!-- </KFD-DOCS> -->
<!-- END_TF_DOCS -->
