terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.102.0"
    }
  }
}
provider "proxmox" {
  endpoint  = "https://pve.internal.lordgasmic.com/"
  api_token = "terraform-prov@pve!terraform=3d269b89-9e2f-47c9-81c5-b1f6a4f8538b"
  insecure  = false
}
resource "proxmox_virtual_environment_vm" "test_vm" {
  name      = "lgc-test-vm"
  node_name = "pve"
  cpu { cores = 2 }
  memory { dedicated = 2048 }
  disk {
    datastore_id = "local"
    file_id      = "local:iso/debian-13-generic-amd64-20260413-2447.qcow2"
    size         = 20
    interface    = "scsi0"
  }
  initialization {
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
    user_account {
      username = "debian"
      keys     = ["ssh-ed25519 AAAAC3..."]
    }
  }
  operation_system {
    type = "126"
  }
}
