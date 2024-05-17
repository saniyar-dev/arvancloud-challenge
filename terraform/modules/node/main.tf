terraform {
  required_providers {
    arvan = {
      source = "arvancloud/arvan"
      version = "0.6.4"
    }
  }
}

resource "arvan_iaas_abrak" "worker_node" {
  name   = var.node_name

  region = var.region
  flavor = var.flavor_id
  key_name = var.key_name
  image {
    type = "distributions"
    name = var.image_name
  }
  disk_size = var.disk_size
}


