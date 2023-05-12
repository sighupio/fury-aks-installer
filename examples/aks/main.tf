terraform {
  required_version = "~> 1.4"
  required_providers {
    kubernetes = "~> 1.13.4"
    azuread    = "~> 1.6.0"
    azurerm    = "~> 2.99.0"
    random     = "~> 3.5.1"
    null       = "~> 3.2.1"
  }
}

provider "azurerm" {
  features {
  }
}

provider "kubernetes" {
  host = data.azurerm_kubernetes_cluster.aks.kube_admin_config.0.host
  client_certificate = base64decode(
    data.azurerm_kubernetes_cluster.aks.kube_admin_config.0.client_certificate,
  )
  client_key = base64decode(
    data.azurerm_kubernetes_cluster.aks.kube_admin_config.0.client_key,
  )
  cluster_ca_certificate = base64decode(
    data.azurerm_kubernetes_cluster.aks.kube_admin_config.0.cluster_ca_certificate,
  )
}

data "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-installer"
  resource_group_name = var.resource_group_name

  depends_on = [
    module.my_cluster,
  ]
}

module "my_cluster" {
  source = "../../modules/aks"

  cluster_version     = "1.25.6"
  cluster_name        = "aks-installer"
  network             = var.network
  subnetworks         = var.subnetworks
  ssh_public_key      = var.ssh_public_key
  dmz_cidr_range      = "11.11.0.0/16"
  resource_group_name = var.resource_group_name
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
        "sighup.io/fury-release" : "v1.25.2"
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
