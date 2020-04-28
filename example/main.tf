provider "azurerm" {
  features {
  }
}

variable "cluster_name" {}
variable "cluster_version" {}
variable "network" {}
variable "subnetworks" { type = list }
variable "dmz_cidr_range" {}
variable "ssh_public_key" {}
variable "node_pools" { type = list }
variable "resource_group_name" {}

module "my-cluster" {
  source = "../modules/aks"

  cluster_version     = var.cluster_version
  cluster_name        = var.cluster_name
  network             = var.network
  subnetworks         = var.subnetworks
  ssh_public_key      = var.ssh_public_key
  dmz_cidr_range      = var.dmz_cidr_range
  node_pools          = var.node_pools
  resource_group_name = var.resource_group_name
}

data "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  resource_group_name = var.resource_group_name

  depends_on = [
    module.my-cluster,
  ]
}

output "kubeconfig" {
  sensitive = true
  value     = <<EOT
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: ${module.my-cluster.cluster_certificate_authority}
    server: ${module.my-cluster.cluster_endpoint}
  name: aks
contexts:
- context:
    cluster: aks
    user: aks
  name: aks
current-context: aks
kind: Config
preferences: {}
users:
- name: aks
  user:
    client-certificate-data: ${data.azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate}
    client-key-data: ${data.azurerm_kubernetes_cluster.aks.kube_config.0.client_key}
EOT
}
