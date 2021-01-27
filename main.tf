# main.tf


terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "1.22.2"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.0.0"
    }
  }
  required_version = ">= 0.12"
}

provider "digitalocean" {
  token = var.do_token
}

module "server-droplet" {
  source          = "./modules/server-droplet"
  ssh_fingerprint = var.ssh_fingerprint
  pvt_key         = var.pvt_key
  server_count    = var.server_count
  providers = {
    digitalocean = digitalocean
  }
}

module "client-droplet" {
  source           = "./modules/client-droplet"
  ssh_fingerprint  = var.ssh_fingerprint
  client_count     = var.client_count
  pvt_key          = var.pvt_key
  consul_server_ip = module.server-droplet.consul_server_ip
}

module "load-balancer" {
  source     = "./modules/load-balancer"
  server_ids = concat(module.server-droplet.server_ids, module.client-droplet.client_ids)
}

module "firewall" {
  source           = "./modules/firewall"
  server_ids       = concat(module.server-droplet.server_ids, module.client-droplet.client_ids)
  load_balancer_id = module.load-balancer.load_balancer_id
  bastion_id       = var.bastion_host_id
}
