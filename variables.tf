variable "proxmox_api_endpoint" {
  type = string
  description = "Proxmox cluster API endpoint https://proxmox-01.my-domain.net:8006"
}

variable "proxmox_api_token" {
  type = string
  description = "Proxmox API token bpg proxmox provider with ID and token"
}

variable "vyos_api_endpoint" {
  type = string
  nullable = false
  sensitive = false
  description = "VyOS API endpoint"
}

variable "vyos_api_key" {
  type = string
  nullable = false
  sensitive = true
  description = "VyOS API key"
}

variable "vyos_shared_network_name" {
  type = string
  nullable = false
  description = "DHCP Shared Network Name"
}

variable "vyos_subnet" {
  type = string
  nullable = false
  description = "DHCP Subnet"
}

variable "cluster_nodes" {
  type = map(object({
    proxmox_node = string
    disk_image = string
    bios_type = string
    node_cpus = number
    node_memory = number
    node_disk_store = string
    ceph_network_ip_address = string
  }))
}

variable "cluster_masters" {
  type = map(object({
    proxmox_node = string
    disk_image = string
    bios_type = string
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