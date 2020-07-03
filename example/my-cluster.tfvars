resource_group_name = "aks-installer"
cluster_name        = "aks-installer"
cluster_version     = "1.16.9"
network             = "aks-installer-local"
subnetworks         = ["aks-installer-local-main"]
ssh_public_key      = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCefFo9ASM8grncpLpJr+DAeGzTtoIaxnqSqrPeSWlCyManFz5M/DDkbnql8PdrENFU28blZyIxu93d5U0RhXZumXk1utpe0L/9UtImnOGG6/dKv9fV9vcJH45XdD3rCV21ZMG1nuhxlN0DftcuUubt/VcHXflBGaLrs18DrMuHVIbyb5WO4wQ9Od/SoJZyR6CZmIEqag6ADx4aFcdsUwK1Cpc51LhPbkdXGGjipiwP45q0I6/Brjxv/Kia1e+RmIRHiltsVBdKKTL9hqu9esbAod9I5BkBtbB5bmhQUVFZehi+d/opPvsIszE/coW5r/g/EVf9zZswebFPcsNr85+x"
dmz_cidr_range      = "11.11.0.0/16"
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
  }
]
