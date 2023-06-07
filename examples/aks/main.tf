terraform {
  required_version = "~> 1.4.6"
  required_providers {
    azurerm = "~> 3.44.0"
    random  = "~> 3.5.1"
    null    = "~> 3.2.1"
  }
}

provider "azurerm" {
  features {
  }
}

module "my_cluster" {
  source = "../../modules/aks"

  cluster_version             = var.cluster_version
  cluster_name                = var.cluster_name
  network_resource_group_name = var.virtual_network_resource_group
  network                     = var.virtual_network_name
  subnetworks                 = var.subnet_names
  ssh_public_key              = var.ssh_public_key
  dmz_cidr_range              = "0.0.0.0/0"
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
        "sighup.io/environment" : "test"
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
      labels : {
        "sighup.io/role" : "extra"
        "sighup.io/environment" : "test"
      }
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
