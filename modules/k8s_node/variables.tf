variable "proxmox_node" {
  description = "Proxmox cluster node"
  type = string
}

variable "proxmox_datastore" {
  description = "Proxmox datastore for the VM disks"
  type = string
  nullable = false
}

variable "proxmox_network_bridge" {
  description = "Proxmox network bridge for the VM"
  type = string
}

variable "proxmox_ceph_network_bridge" {
  description = "Proxmox network bridge for the VM to connect to CEPH"
  type = string
}

variable "ceph_network_ip_address" {
  description = "IP address on the CEPH-facing network interface"
  type = string
}

variable "hostname" {
  description = "Hostname for the k8s node"
  type = string
}

variable "domainname" {
  description = "Domain name for the k8s node"
  type = string
}

variable "ipv6_prefix" {
  description = "IPv6 prefix for the k8s node"
  type = string
}

variable "ipv6_suffix" {
  description = "IPv6 suffix for the k8s node"
  type = string
}

variable "cpus" {
  description = "Number of vcpus for the node"
  type = number
}

variable "memory" {
  description = "Memory allocation for the node"
  type = number
}

variable "bios_type" {
  description = "BIOS type for the VM"
  type = string
}

variable "image_file" {
  description = "Path to the cloud image file"
  type = string
}
