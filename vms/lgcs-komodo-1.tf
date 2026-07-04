resource "proxmox_virtual_environment_vm" "lgcs-komodo-1" {
  name      = "lgcs-komodo-1"
  node_name = "pve"
  agent {
    enabled = true
  }
  cpu {
    cores = 4
    type  = "host"
  }
  memory { dedicated = 8192 }
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
    meta_data_file_id = proxmox_virtual_environment_file.lgcs-komodo-1-hostname.id
  }
  network_device {
    mac_address = "bc:24:11:00:00:01"
    bridge      = "vmbr0"
    firewall    = true
  }
  operating_system {
    type = "l26"
  }
}

resource "proxmox_virtual_environment_file" "lgcs-komodo-1-hostname" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = "pve"

  source_raw {
    data = <<-EOF
    #cloud-config
    local-hostname: lgcs-komodo-1
    EOF

    file_name = "lgcs-komodo-1-hostname.yaml"
  }
}
