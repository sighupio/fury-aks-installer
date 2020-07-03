resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  kubernetes_version  = var.cluster_version
  resource_group_name = data.azurerm_resource_group.aks.name
  location            = data.azurerm_resource_group.aks.location
  dns_prefix          = var.cluster_name

  default_node_pool {
    name                  = var.node_pools[0].name
    vm_size               = var.node_pools[0].instance_type
    node_count            = var.node_pools[0].min_size
    enable_auto_scaling   = true
    enable_node_public_ip = false
    max_pods              = 250
    node_labels           = var.node_pools[0].labels
    node_taints           = var.node_pools[0].taints
    type                  = "VirtualMachineScaleSets"
    os_disk_size_gb       = var.node_pools[0].volume_size
    vnet_subnet_id        = data.azurerm_subnet.subnetwork.id
    min_count             = var.node_pools[0].min_size
    max_count             = var.node_pools[0].max_size
  }

  service_principal {
    client_id     = azuread_application.aks.application_id
    client_secret = azuread_service_principal_password.aks.value
  }

  addon_profile {
    aci_connector_linux {
      enabled = false
    }
    azure_policy {
      enabled = false
    }
    http_application_routing {
      enabled = false
    }
    kube_dashboard {
      enabled = false
    }
    oms_agent {
      enabled = false
    }
  }

  # api_server_authorized_ip_ranges is not compatible with private clusters.
  # Maybe we should consider to create some Security Groups around the
  # control-plane and the node_pools
  # api_server_authorized_ip_ranges = [var.dmz_cidr_range]

  enable_pod_security_policy = false

  linux_profile {
    admin_username = "ubuntu"

    ssh_key {
      key_data = var.ssh_public_key
    }
  }

  # https://github.com/terraform-providers/terraform-provider-azurerm/issues/6525
  # 2.7.0 Fails
  # 2.5.0 Works
  network_profile {
    load_balancer_sku = "standard"
    load_balancer_profile {
      managed_outbound_ip_count = 1
    }
    network_plugin     = "azure"
    network_policy     = "calico"
    dns_service_ip     = "10.10.0.10"
    docker_bridge_cidr = "172.18.0.1/16"
    service_cidr       = "10.10.0.0/16"
  }


  node_resource_group = "${data.azurerm_resource_group.aks.name}-nodes"

  private_cluster_enabled = true

  role_based_access_control {
    enabled = true

    azure_active_directory {
      client_app_id     = azuread_application.aad_client.application_id
      server_app_id     = azuread_application.aad_server.application_id
      server_app_secret = azuread_service_principal_password.aad_server.value
    }
  }

  lifecycle {
    ignore_changes = [service_principal]
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "aks" {
  count = length(var.node_pools) - 1
  lifecycle {
    ignore_changes = [
      node_count
    ]
  }
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  name                  = element(var.node_pools, count.index + 1).name
  node_count            = element(var.node_pools, count.index + 1).min_size
  vm_size               = element(var.node_pools, count.index + 1).instance_type
  enable_node_public_ip = false
  max_pods              = 250
  os_disk_size_gb       = element(var.node_pools, count.index + 1).volume_size
  os_type               = "Linux"
  vnet_subnet_id        = data.azurerm_subnet.subnetwork.id
  enable_auto_scaling   = true
  min_count             = element(var.node_pools, count.index + 1).min_size
  max_count             = element(var.node_pools, count.index + 1).max_size
  node_labels           = element(var.node_pools, count.index + 1).labels
  node_taints           = element(var.node_pools, count.index + 1).taints
}

resource "null_resource" "aks" {
  triggers = {
    aks_kubernetes_version = azurerm_kubernetes_cluster.aks.kubernetes_version
  }

  provisioner "local-exec" {
    command     = "./update-cluster-node-pools.sh ${var.cluster_name} ${var.resource_group_name}"
    working_dir = path.module
  }
}
