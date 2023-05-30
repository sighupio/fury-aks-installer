output "kubeconfig_admin" {
  value     = module.my_cluster.kubeconfig_admin
  sensitive = true
}

output "kubeconfig" {
  value     = module.my_cluster.kubeconfig
  sensitive = true
}
