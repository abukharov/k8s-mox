terraform {
  required_providers {
    opnsense = {
      source = "gxben/opnsense"
      version = "~> 0.3.0"
    }
    proxmox = {
      source = "bpg/proxmox"
      version = "~> 0.57.1"
    }
  }
}
