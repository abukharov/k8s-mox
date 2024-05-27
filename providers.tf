provider "opnsense" {
  uri = var.opnsense_uri
  user = var.opnsense_username
  password = var.opnsense_password
}

provider "proxmox" {
  endpoint  = var.proxmox_api_endpoint
  api_token = var.proxmox_api_token
  ssh {
    agent    = true
    username = "root"
  }
}
