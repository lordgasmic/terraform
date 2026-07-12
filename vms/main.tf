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

variable "ansible_password" {
  type        = string
  sensitive   = true
  description = "The pre-generated SHA-512 password hash for the ansible user"
}
