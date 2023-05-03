# No provider should be included into modules
# https://cloud.google.com/docs/terraform/best-practices-for-terraform#providers-backends

#provider "kubernetes" {
#  host = azurerm_kubernetes_cluster.aks.kube_config[0].host
#  client_certificate = base64decode(
#    azurerm_kubernetes_cluster.aks.kube_config[0].client_certificate,
#  )
#  client_key = base64decode(
#    azurerm_kubernetes_cluster.aks.kube_config[0].client_key,
#  )
#  cluster_ca_certificate = base64decode(
#    azurerm_kubernetes_cluster.aks.kube_config[0].cluster_ca_certificate,
#  )
#}
