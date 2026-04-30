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
resource "proxmox_virtual_environment_vm" "lgcs-dev-machine" {
  name      = "lgc-dev-machine"
  node_name = "pve"
  agent {
    enabled = true
  }
  cpu {
    cores = 8
    type  = "x86-64-v2-AES"
  }
  memory { dedicated = 16384 }
  disk {
    datastore_id = "datastore"
    file_id      = "local:import/debian-13-generic-amd64-20260413-2447.qcow2"
    size         = 80
    interface    = "scsi0"
  }
  initialization {
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
    user_data_file_id = proxmox_virtual_environment_file.cloud_config.id
  }
  network_device {
    bridge = "vmbr0"
  }
  operating_system {
    type = "l26"
  }
}

resource "proxmox_virtual_environment_file" "cloud_config" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = "pve"

  source_raw {
    data = <<-EOT
      #cloud-config
      users:
        - name: devuser
          sudo: ALL=(ALL) NOPASSWD:ALL
          groups: sudo
          shell: /bin/bash

        - name: ansible
          sudo: ALL=(ALL) NOPASSWD:/usr/bin/apt
          groups: sudo
          shell: /bin/bash
          ssh_authorized_keys:
            - ${trimspace(file("${path.module}/id_ansible.pub"))}
    EOT

    file_name = "cloud-config.yaml"
  }
}
