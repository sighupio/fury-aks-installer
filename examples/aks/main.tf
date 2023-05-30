terraform {
  required_version = "~> 1.4"
  required_providers {
    azurerm = "~> 3.44.1"
    random  = "~> 3.5.1"
    null    = "~> 3.2.1"
  }
}

provider "azurerm" {
  features {
  }
}

data "azurerm_resource_group" "network" {
  name = "aks-installer-network-rg"
}

module "my_cluster" {
  source = "../../modules/aks"

  cluster_version             = "1.25.6"
  cluster_name                = "aks-installer"
  network_resource_group_name = data.azurerm_resource_group.network.name
  network                     = var.network
  subnetworks                 = var.subnetworks
  ssh_public_key              = file("~/.ssh/id_rsa.pub")
  dmz_cidr_range              = "11.11.0.0/16"
  resource_group_name         = var.resource_group_name
  location                    = var.location
  tags                        = {}
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

data "azurerm_client_config" "current" {

}

data "azurerm_subscription" "current" {

}

# This gives the connected user the admin role on the cluster (it's not the admin kubeconfig)
resource "azurerm_role_assignment" "aks-admin" {
  role_definition_name = "Azure Kubernetes Service RBAC Cluster Admin"
  principal_id         = data.azurerm_client_config.current.object_id
  scope                = data.azurerm_subscription.current.id
}
