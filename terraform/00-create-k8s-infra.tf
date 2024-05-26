terraform {
  required_providers {
    arvan = {
      source = "arvancloud/arvan"
      version = "0.6.4"
    }
  }
}

variable "arvan_apikey" {}
provider "arvan" {
  api_key = var.arvan_apikey
}

resource "arvan_iaas_abrak" "master_node" {
  region = var.region
  flavor = var.flavor_id
  name   = var.master_node_name
  key_name = var.key_name
  image {
    type = "distributions"
    name = var.image_name
  }
  disk_size = var.disk_size
}

module "worker_nodes" {
  source = "./modules/node"

  for_each = toset(var.worker_node_names)

  node_name = each.value
  region = var.region
  flavor_id = var.flavor_id
  key_name = var.key_name
  image_name = var.image_name
  disk_size = var.disk_size

}
