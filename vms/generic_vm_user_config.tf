resource "proxmox_virtual_environment_file" "cloud_config" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = "pve"

  source_raw {
    data = <<-EOT
      #cloud-config
      users:
        - name: debian
          sudo: ALL=(ALL) NOPASSWD:ALL
          groups: sudo
          shell: /bin/bash
          ssh_authorized_keys:
            - ${trimspace(file("${path.module}/id_lordgasmic.pub"))}

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
