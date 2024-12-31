module "masters" {
  source = "./modules/k8s_node"

  providers = {
    proxmox = proxmox
  }

  proxmox_network_bridge = "vmvnet"
  proxmox_ceph_network_bridge = "cebr0"
  domainname            = "cosmos.st"

  for_each = var.cluster_masters
  proxmox_node = each.value.proxmox_node
  image_file = each.value.disk_image
  hostname = each.key
  cpus = each.value.node_cpus
  memory = each.value.node_memory
  bios_type = each.value.bios_type
  proxmox_datastore = each.value.node_disk_store
  ceph_network_ip_address = each.value.ceph_network_ip_address
}

module "workers" {
  source = "./modules/k8s_node"

  providers = {
    proxmox = proxmox
  }

  proxmox_network_bridge = "vmvnet"
  proxmox_ceph_network_bridge = "cebr0"
  domainname            = "cosmos.st"

  for_each = var.cluster_nodes
  proxmox_node = each.value.proxmox_node
  image_file = each.value.disk_image
  hostname = each.key
  cpus = each.value.node_cpus
  memory = each.value.node_memory
  bios_type = each.value.bios_type
  proxmox_datastore = each.value.node_disk_store
  ceph_network_ip_address = each.value.ceph_network_ip_address
}

resource "vyos_config" "node_dhcp_static_lease" {
  for_each = merge(module.masters, module.workers)
  path = "service dhcp-server shared-network-name ${var.vyos_shared_network_name} subnet ${var.vyos_subnet} static-mapping ${each.value.hostname}"
  value = jsonencode({
    "ip-address" = each.value.ip_address,
    "mac" = lower(each.value.mac_address)
  })
}

resource "local_file" "inventory" {
  content = templatefile("${path.module}/templates/inventory.tftpl", {
    connection_strings_master = join("\n", formatlist("%s ansible_user=alexv ansible_host=%s etcd_member_name=etcd%d",
      values(module.masters).*.fqdn,
      values(module.masters).*.ip_address,
    range(1, length(keys(module.masters)) + 1))),
    connection_strings_worker = join("\n", formatlist("%s ansible_user=alexv ansible_host=%s",
      values(module.workers).*.fqdn,
      values(module.workers).*.ip_address)),
    list_master = join("\n", formatlist("%s", values(module.masters).*.fqdn)),
    list_worker = join("\n", formatlist("%s", values(module.workers).*.fqdn))
  })
  filename = var.inventory_file
}
