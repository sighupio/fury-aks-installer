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
|kubernetes | `~>1.13.4`|
|azuread    | `~>1.5.1`|
|azurerm    | `~>2.60.0`|
|random     | `~>3.1.3`|
|null       | `~>3.1.`|

## Inputs

| Name | Description | Default | Required |
|------|-------------|---------|:--------:|
| cluster\_name | Unique cluster name. Used in multiple resources to identify your cluster resources | n/a | yes |
| cluster\_version | Kubernetes Cluster Version. Look at the cloud providers documentation to discover available versions. EKS example -> 1.16, GKE example -> 1.16.8-gke.9 | n/a | yes |
| dmz\_cidr\_range | Network CIDR range from where cluster control plane will be accessible | n/a | yes |
| network | Network where the Kubernetes cluster will be hosted | n/a | yes |
| node\_pools | An object list defining node pools configurations | `[]` | no |
| resource\_group\_name | Resource group name where every resource will be placed. Required only in AKS installer (*) | n/a | yes |
| ssh\_public\_key | Cluster administrator public ssh key. Used to access cluster nodes with the operator\_ssh\_user | n/a | yes |
| subnetworks | List of subnets where the cluster will be hosted | n/a | yes |
| tags | The tags to apply to all resources | `{}` | no |  

## Outputs

| Name | Description |
|------|-------------|
| cluster\_certificate\_authority | The base64 encoded certificate data required to communicate with your cluster. Add this to the certificate-authority-data section of the kubeconfig file for your cluster |
| cluster\_endpoint | The endpoint for your Kubernetes API server |
| operator\_ssh\_user | SSH user to access cluster nodes with ssh\_public\_key |

## Usage

```hcl
provider "azurerm" {
  features {
  }
}

provider "kubernetes" {
  host = module.my-cluster.kubeconfig.host
  client_certificate = base64decode(
    module.my-cluster.kubeconfig.client_certificate,
  )
  client_key = base64decode(
    module.my-cluster.kubeconfig.client_key,
  )
  cluster_ca_certificate = base64decode(
    module.my-cluster.kubeconfig.cluster_ca_certificate,
  )
}

module "my-cluster" {
  source = "../../modules/aks"

  cluster_version     = "1.16.9"
  cluster_name        = "aks-installer"
  network             = "aks-installer-local"
  subnetworks         = ["aks-installer-local-main"]
  ssh_public_key      = "ssh-rsa my-public-key"
  dmz_cidr_range      = "11.11.0.0/16"
  resource_group_name = "aks-installer"
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

```

<!-- </KFD-DOCS> -->
<!-- END_TF_DOCS -->