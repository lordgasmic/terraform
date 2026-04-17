terraform {
required_providers {
proxmox = {
source = "bpg/proxmox"
version = "0.66.1"
}
}
}
provider "proxmox" {
endpoint = "https://pve.internal.lordgasmic.com/"
api_token = "terraform-prov@pve!terraform=3d269b89-9e2f-47c9-81c5-b1f6a4f8538b"
insecure = true
}
resource "proxmox_virtual_machine" "debian_trixie" {
name = "debian-trixie-prod"
node_name = "pve"
cpu { cores = 2 }
memory { dedicated = 2048 }
disk {
datastore_id = "local-lvm"
file_id = "local:iso/debian-13-generic-amd64.qcow2"
size = 20
}
initialization {
ip_config {
ipv4 {
address = "192.168.1.100/24"
gateway = "192.168.1.1"
}
}
user_account {
username = "debian"
keys = ["ssh-ed25519 AAAAC3..."]
}
}
}
