provider "proxmox" {
  endpoint  = var.proxmox_api_endpoint
  api_token = var.proxmox_api_token
  ssh {
    agent    = true
    username = "root"
  }
}

provider "vyos" {
  endpoint = var.vyos_api_endpoint
  api_key  = var.vyos_api_key
}
