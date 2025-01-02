terraform {
  required_providers {
    vyos = {
      source = "TGNThump/vyos"
      version = "~> 2.1.0"
    }
    proxmox = {
      source = "bpg/proxmox"
      version = "~> 0.57.1"
    }
    random = {
      source = "hashicorp/random"
      version = "~> 3.6.3"
    }
  }
}
