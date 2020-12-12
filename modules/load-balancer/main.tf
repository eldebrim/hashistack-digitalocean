# modules/load-balancer/main.tf
# Create a load balancer to connect to servers and clients

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
  description = "list of servers"
}

resource "digitalocean_loadbalancer" "public" {
  name   = "loadbalancer-1"
  region = "sfo3"

  forwarding_rule {
    entry_port     = 80
    entry_protocol = "http"

    target_port     = 9999
    target_protocol = "http"
  }

  healthcheck {
    port     = 22
    protocol = "tcp"
  }

  droplet_ids = var.server_ids
}

output "load_balancer_id" {
  value = digitalocean_loadbalancer.public.id
}
