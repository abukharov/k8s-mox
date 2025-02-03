resource "proxmox_virtual_environment_file" "ubuntu_cloud_init" {
  content_type = "snippets"
  datastore_id = "isostor"
  node_name    = "caspar"

  source_raw {
    data = templatefile("${path.module}/templates/cloud-config.tftpl", {
      domainname = var.domainname,
      hostname   = var.hostname,
    })

    file_name = "${var.hostname}.cloud-config.yaml"
  }
}

resource "proxmox_virtual_environment_vm" "k8s_node_vm" {
  name        = var.hostname
  description = "k8s node Managed by Terraform"
  tags        = ["terraform", "ubuntu", "k8s"]

  node_name = var.proxmox_node

  cpu {
    cores = var.cpus
    type = "host"
  }

  memory {
    dedicated = var.memory
  }

  bios = var.bios_type

  machine = var.bios_type == "ovmf" ? "q35" : ""

  dynamic "efi_disk" {
    for_each = var.bios_type == "ovmf" ? ["apply"] : []
    content {
      datastore_id = var.proxmox_datastore
      type         = "4m"
      pre_enrolled_keys = true
    }
  }

  agent {
    enabled = true
  }

  startup {
    order      = "3"
    up_delay   = "60"
    down_delay = "60"
  }

  vga {
    enabled = true
    type    = "qxl"
  }

  disk {
    datastore_id = var.proxmox_datastore
    file_id      = var.image_file
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = 40
    file_format  = "raw"
  }

  initialization {
    ip_config {
      ipv4 {
        address = "dhcp"
      }
      ipv6 {
        address = cidrhost(var.ipv6_prefix, var.ipv6_suffix)
      }
    }
    ip_config {
      ipv4 {
        address = var.ceph_network_ip_address
      }
    }
    datastore_id = var.proxmox_datastore
    interface = var.bios_type == "ovmf" ? "scsi9" : "ide2"
    user_data_file_id = proxmox_virtual_environment_file.ubuntu_cloud_init.id
  }

  network_device {
    bridge = var.proxmox_network_bridge
  }

  network_device {
    bridge = var.proxmox_ceph_network_bridge
  }

  operating_system {
    type = "l26"
  }

  keyboard_layout = "en-us"

  lifecycle {
    ignore_changes = [
      network_device,
      initialization,
      vga,
      hostpci,
    ]
  }
}

output "vm_id" {
  value = proxmox_virtual_environment_vm.k8s_node_vm.id
}

output "hostname" {
  description = "Hostname of the node"
  value = var.hostname
}

output "fqdn" {
  description = "FQDN of the node"
  value = "${var.hostname}.${var.domainname}"
}

output "ip_address" {
  value = proxmox_virtual_environment_vm.k8s_node_vm.ipv4_addresses[index(proxmox_virtual_environment_vm.k8s_node_vm.network_interface_names, "eth0")][0]
}

output "ipv6_address" {
  value = proxmox_virtual_environment_vm.k8s_node_vm.ipv6_addresses[index(proxmox_virtual_environment_vm.k8s_node_vm.network_interface_names, "eth0")][0]
}

output "mac_address" {
  value = proxmox_virtual_environment_vm.k8s_node_vm.mac_addresses[index(proxmox_virtual_environment_vm.k8s_node_vm.network_interface_names, "eth0")]
}