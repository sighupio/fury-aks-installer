output "kubeconfig_admin" {
  description = "The Admin kubeconfig to be used by kubectl"
  value       = azurerm_kubernetes_cluster.aks.kube_admin_config_raw
  sensitive   = true
}

output "kubeconfig" {
  description = "The User kubeconfig to be used by kubectl"
  value       = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive   = true
}