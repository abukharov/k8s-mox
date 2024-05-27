variable "proxmox_api_endpoint" {
  type = string
  description = "Proxmox cluster API endpoint https://proxmox-01.my-domain.net:8006"
}

variable "proxmox_api_token" {
  type = string
  description = "Proxmox API token bpg proxmox provider with ID and token"
}

variable "opnsense_uri" {
  type = string
  nullable = false
  sensitive = false
}

variable "opnsense_username" {
  type = string
  nullable = false
  sensitive = true
}

variable "opnsense_password" {
  type = string
  nullable = false
  sensitive = true
}

variable "opnsense_iface" {
  type = string
  nullable = false
  sensitive = false
}

variable "cluster_nodes" {
  type = map(object({
    proxmox_node = string
    node_cpus = number
    node_memory = number
    node_disk_store = string
    ceph_network_ip_address = string
  }))
}

variable "cluster_masters" {
  type = map(object({
    proxmox_node = string
    node_cpus = number
    node_memory = number
    node_disk_store = string
    ceph_network_ip_address = string
  }))
}

variable "inventory_file" {
  description = "Kubespray inventory file"
  type = string
  default = "inventory.ini"
}