variable "master_node_name" {
  description = "Name of master node"
  type = string
}

variable "worker_node_names" {
  description = "Names of worker nodes"
  type = list(string)
}

variable "region" {
  description = "Name of arvan abrak region for nodes"
  type = string
}

variable "flavor_id" {
  description = "PlanID for nodes"
  type = string
}

variable "key_name" {
  description = "SSH key name in my account"
  type = string
}

variable "image_name" {
  description = "Image name for nodes"
  type = string
}

variable "disk_size" {
  description = "Disk size for nodes"
  type = string
}

