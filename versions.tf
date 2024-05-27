terraform {
  required_providers {
    opnsense = {
      source = "gxben/opnsense"
      version = "~> 0.3.0"
    }
    ignition = {
      source = "community-terraform-providers/ignition"
      version = "~> 2.3.5"
    }
    proxmox = {
      source = "bpg/proxmox"
      version = "~> 0.57.1"
    }
  }
}