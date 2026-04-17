terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.102.0"
    }
  }
}
provider "proxmox" {
  endpoint  = "https://172.16.0.10:8006"
  api_token = "terraform-prov@pve!terraform=3d269b89-9e2f-47c9-81c5-b1f6a4f8538b"
  insecure  = true
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
      password = random_password.ubuntu_vm_password.result
    }
  }
  operating_system {
    type = "l26"
  }
}

resource "random_password" "ubuntu_vm_password" {
  length           = 16
  override_special = "_%@"
  special          = true
}

output "ubuntu_vm_password" {
  value     = random_password.ubuntu_vm_password.result
  sensitive = true
}
