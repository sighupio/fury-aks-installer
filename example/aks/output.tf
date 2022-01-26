data "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-installer"
  resource_group_name = "aks-installer"

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
    client-certificate-data: ${data.azurerm_kubernetes_cluster.aks.kube_admin_config.0.client_certificate}
    client-key-data: ${data.azurerm_kubernetes_cluster.aks.kube_admin_config.0.client_key}
EOT
}
