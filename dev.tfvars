opnsense_uri = "https://connaught.cosmos.st"
opnsense_username = "terraform"
opnsense_password = "Qwerty+1"
opnsense_iface = "opt2"

cluster_nodes = {
  "worker0" : {
    proxmox_node    = "balthasar"
    node_cpus       = 2
    node_memory     = 2048
    node_disk_store = "faststor"
  }
}

cluster_masters = {
  "master0" : {
    proxmox_node    = "melchior"
    node_cpus       = 2
    node_memory     = 4096
    node_disk_store = "faststor"
  },
}
