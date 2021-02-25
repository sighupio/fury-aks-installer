# Control Plane subnet and security Groups
data "azurerm_subnet" "aks" {
  name                 = var.node_pools[0].subnetworks != null && length(var.node_pools[0].subnetworks) > 0 ? var.node_pools[0].subnetworks[0] : var.subnetworks[0]
  virtual_network_name = var.network
  resource_group_name  = data.azurerm_resource_group.aks.name
}

# Node Pool subnets and security Groups
data "azurerm_subnet" "node_pools" {
  count                = length(var.node_pools)
  name                 = var.node_pools[count.index].subnetworks != null && length(var.node_pools[count.index].subnetworks) > 0 ? var.node_pools[count.index].subnetworks[0] : var.subnetworks[0]
  virtual_network_name = var.network
  resource_group_name  = data.azurerm_resource_group.aks.name
}

# Security Rule enabling local.parsed_dmz_cidr_range to access the control plane endpoint. Cloud Installers v1.5.0
resource "azurerm_network_security_rule" "aks" {
  name                         = "${var.cluster_name} - Control Plane"
  priority                     = 200
  direction                    = "Inbound"
  access                       = "Allow"
  protocol                     = "Tcp"
  source_port_range            = "*"
  destination_port_range       = "443" # Control plane
  source_address_prefixes      = local.parsed_dmz_cidr_range
  destination_address_prefixes = data.azurerm_subnet.aks.address_prefixes
  resource_group_name          = data.azurerm_resource_group.aks.name
  network_security_group_name  = element(split("/", data.azurerm_subnet.aks.network_security_group_id), length(split("/", data.azurerm_subnet.aks.network_security_group_id)) - 1)
}

# Custom firewall rules v1.5.0 in the cloud installers
locals {
  azurerm_network_security_rules = flatten([
    [for nodePool in var.node_pools : [
      [for rule in nodePool.additional_firewall_rules : {
        name                         = rule.name
        priority                     = 300
        direction                    = rule.direction == "ingress" ? "Inbound" : "Outbound"
        access                       = "Allow"
        protocol                     = rule.protocol
        source_port_range            = "*"
        destination_port_range       = rule.ports
        source_address_prefixes      = rule.direction == "ingress" ? [rule.cidr_block] : element(data.azurerm_subnet.node_pools.*.address_prefixes, index(var.node_pools.*.name, nodePool.name))
        destination_address_prefixes = rule.direction == "egress" ? [rule.cidr_block] : element(data.azurerm_subnet.node_pools.*.address_prefixes, index(var.node_pools.*.name, nodePool.name))
        resource_group_name          = data.azurerm_resource_group.aks.name
        network_security_group_name  = element(split("/", element(data.azurerm_subnet.node_pools.*.network_security_group_id, index(var.node_pools.*.name, nodePool.name))), length(split("/", element(data.azurerm_subnet.node_pools.*.network_security_group_id, index(var.node_pools.*.name, nodePool.name)))) - 1)
      }]
      ]
    ]
  ])
}

resource "azurerm_network_security_rule" "node_pools" {
  count = length(local.azurerm_network_security_rules)

  name                         = local.azurerm_network_security_rules[count.index].name
  priority                     = local.azurerm_network_security_rules[count.index].priority + count.index # Required because the priority is unique across rules in a security group
  direction                    = local.azurerm_network_security_rules[count.index].direction
  access                       = local.azurerm_network_security_rules[count.index].access
  protocol                     = local.azurerm_network_security_rules[count.index].protocol
  source_port_range            = local.azurerm_network_security_rules[count.index].source_port_range
  destination_port_range       = local.azurerm_network_security_rules[count.index].destination_port_range
  source_address_prefixes      = local.azurerm_network_security_rules[count.index].source_address_prefixes
  destination_address_prefixes = local.azurerm_network_security_rules[count.index].destination_address_prefixes
  resource_group_name          = local.azurerm_network_security_rules[count.index].resource_group_name
  network_security_group_name  = local.azurerm_network_security_rules[count.index].network_security_group_name
}

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
    max_pods              = var.node_pools[0].max_pods != null ? var.node_pools[0].max_pods : 250
    node_labels           = var.node_pools[0].labels
    node_taints           = var.node_pools[0].taints
    type                  = "VirtualMachineScaleSets"
    os_disk_size_gb       = var.node_pools[0].volume_size
    vnet_subnet_id        = element(data.azurerm_subnet.node_pools.*.id, index(var.node_pools.*.name, var.node_pools[0].name))
    min_count             = var.node_pools[0].min_size
    max_count             = var.node_pools[0].max_size
    tags                  = merge(var.tags, var.node_pools[0].tags)
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
  # api_server_authorized_ip_ranges = [local.parsed_dmz_cidr_range]

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

  tags = var.tags

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
  max_pods              = element(var.node_pools, count.index + 1).max_pods != null ? element(var.node_pools, count.index + 1).max_pods : 250
  os_disk_size_gb       = element(var.node_pools, count.index + 1).volume_size
  os_type               = "Linux"
  vnet_subnet_id        = element(data.azurerm_subnet.node_pools.*.id, index(var.node_pools.*.name, var.node_pools[count.index + 1].name))
  enable_auto_scaling   = true
  min_count             = element(var.node_pools, count.index + 1).min_size
  max_count             = element(var.node_pools, count.index + 1).max_size
  node_labels           = element(var.node_pools, count.index + 1).labels
  node_taints           = element(var.node_pools, count.index + 1).taints
  tags                  = merge(var.tags, element(var.node_pools, count.index + 1).tags)
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
