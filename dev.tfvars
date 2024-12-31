vyos_shared_network_name = "dhcp_vms"
vyos_subnet = "10.125.0.0/24"

cluster_nodes = {
  "worker0" : {
    proxmox_node    = "balthasar"
    node_cpus       = 2
    node_memory     = 2048
    node_disk_store = "faststor"
    ceph_network_ip_address = "10.113.1.11/27"
  }
}

cluster_masters = {
  "master0" : {
    proxmox_node    = "melchior"
    node_cpus       = 2
    node_memory     = 4096
    node_disk_store = "faststor"
    ceph_network_ip_address = "10.113.1.12/27"
  },
}
