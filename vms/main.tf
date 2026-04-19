terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.103.0"
    }
  }
}
provider "proxmox" {
  endpoint  = "https://172.16.0.10:8006/"
  api_token = "terraform-prov@pam!terraform=832349af-e6c7-4d2a-a627-0e194555d7a7"
  insecure  = true

  ssh {
    agent    = true             # Uses your local ssh-agent
    username = "terraform-prov" # Required when using API tokens
    # Or instead of agent:
    # private_key = file("~/.ssh/id_rsa")
  }
}
resource "proxmox_virtual_environment_vm" "test_vm" {
  name      = "lgc-test-vm"
  node_name = "pve"
  agent {
    enabled = false
  }
  cpu {
    cores = 2
    type  = "x86-64-v2-AES"
  }
  memory { dedicated = 2048 }
  disk {
    datastore_id = "datastore"
    # file_id      = "local:images/debian-13-generic-amd64-20260413-2447.qcow2"
    import_from = proxmox_download_file.latest_debian_13.id
    size        = 20
    interface   = "scsi0"
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

resource "proxmox_download_file" "latest_debian_13" {
  content_type = "import"
  datastore_id = "local"
  node_name    = "pve"
  url          = "https://cloud.debian.org/images/cloud/trixie/20260413-2447/debian-13-generic-amd64-20260413-2447.qcow2"
  # need to rename the file to *.qcow2 to indicate the actual file format for import
  file_name = "debian-13-generic-amd64.qcow2"
}

output "ubuntu_vm_password" {
  value     = random_password.ubuntu_vm_password.result
  sensitive = true
}
