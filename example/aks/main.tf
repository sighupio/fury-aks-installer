provider "azurerm" {
  features {
  }
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
