# modules/firewall/main.tf
# Create a firewall around all servers

terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "1.22.2"
    }
  }
  required_version = ">= 0.12"
}

variable "server_ids" {
  type        = list(number)
  description = "list of servers"
}

variable "load_balancer_id" {
  description = "IP Address of load balancer"
}

variable "bastion_id" {
  type        = number
  description = "Droplet id of bastion host"
}

#null resource to ensure dependency of server module
resource "null_resource" "dependency_manager" {
  triggers = {
    dependency_id = "${var.load_balancer_id}"
  }
}

resource "digitalocean_firewall" "web" {
  name = "firewall-1"

  droplet_ids = var.server_ids

  inbound_rule {
    protocol                  = "tcp"
    port_range                = "22"
    source_droplet_ids        = [var.bastion_id]
    source_load_balancer_uids = [var.load_balancer_id]
  }
  inbound_rule {
    protocol                  = "tcp"
    port_range                = "9999"
    source_load_balancer_uids = [var.load_balancer_id]
  }
  inbound_rule {
    protocol           = "tcp"
    port_range         = "all"
    source_droplet_ids = var.server_ids
  }
  inbound_rule {
    protocol           = "udp"
    port_range         = "all"
    source_droplet_ids = var.server_ids
  }


  outbound_rule {
    protocol              = "tcp"
    port_range            = "all"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
  outbound_rule {
    protocol              = "udp"
    port_range            = "all"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

}
