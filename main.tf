resource "proxmox_virtual_environment_file" "ubuntu_cloud_image" {
  content_type = "iso"
  datastore_id = "isostor"
  node_name    = "caspar"

  source_file {
    # you may download this image locally on your workstation and then use the local path instead of the remote URL
    path      = "https://cloud-images.ubuntu.com/releases/24.04/release/ubuntu-24.04-server-cloudimg-amd64.img"

    # you may also use the SHA256 checksum of the image to verify its integrity
    checksum = "b60205f4cc48a24b999ad0bd61ceb9fe28abfe4ac3701acb7bb5d6b0b5fdc624"
  }
}

module "masters" {
  source = "./modules/k8s_node"

  providers = {
    proxmox = proxmox
  }

  proxmox_network_bridge = "vmbr0"
  proxmox_ceph_network_bridge = "cebr0"
  domainname            = "cosmos.st"
  image_file            = proxmox_virtual_environment_file.ubuntu_cloud_image.id

  for_each = var.cluster_masters
  proxmox_node = each.value.proxmox_node
  hostname = each.key
  cpus = each.value.node_cpus
  memory = each.value.node_memory
  proxmox_datastore = each.value.node_disk_store
  ceph_network_ip_address = each.value.ceph_network_ip_address
}

module "workers" {
  source = "./modules/k8s_node"

  providers = {
    proxmox = proxmox
  }

  proxmox_network_bridge = "vmbr0"
  proxmox_ceph_network_bridge = "cebr0"
  domainname            = "cosmos.st"
  image_file            = proxmox_virtual_environment_file.ubuntu_cloud_image.id

  for_each = var.cluster_nodes
  proxmox_node = each.value.proxmox_node
  hostname = each.key
  cpus = each.value.node_cpus
  memory = each.value.node_memory
  proxmox_datastore = each.value.node_disk_store
  ceph_network_ip_address = each.value.ceph_network_ip_address
}

resource "opnsense_dhcp_static_map" "node_dhcp_map" {
  interface = var.opnsense_iface

  for_each = merge(module.masters, module.workers)
  mac = each.value.mac_address
  ipaddr = each.value.ip_address
  hostname = each.value.hostname
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