vyos_shared_network_name = "dhcp_vms"
vyos_subnet = "10.125.0.0/24"

cluster_nodes = {
  "k8s-node-0" : {
    proxmox_node    = "caspar"
    disk_image      = "isostor:iso/debian-12-genericcloud-amd64.img"
    bios_type       = "ovmf"
    node_cpus       = 8
    node_memory     = 8192
    node_disk_store = "faststor"
    ceph_network_ip_address = "10.113.1.1/27"
  }
  "k8s-node-2" : {
    proxmox_node    = "balthasar"
    disk_image      = "isostor:iso/debian-12-genericcloud-amd64.img"
    bios_type       = "ovmf"
    node_cpus       = 8
    node_memory     = 8192
    node_disk_store = "faststor"
    ceph_network_ip_address = "10.113.1.3/27"
  }
  "k8s-node-3" : {
    proxmox_node    = "melchior"
    disk_image      = "isostor:iso/debian-12-genericcloud-amd64.img"
    bios_type       = "ovmf"
    node_cpus       = 8
    node_memory     = 8192
    node_disk_store = "faststor"
    ceph_network_ip_address = "10.113.1.4/27"
  }
}

cluster_masters = {
  "k8s-master-0" : {
    proxmox_node    = "balthasar"
    disk_image      = "isostor:iso/ubuntu-24.04-server-cloudimg-amd64.img"
    bios_type       = "seabios"
    node_cpus       = 4
    node_memory     = 4096
    node_disk_store = "faststor"
    ceph_network_ip_address = "10.113.1.9/27"
  },
}
