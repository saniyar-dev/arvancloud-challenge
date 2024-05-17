variable "node_name" {
  description = "Name of the worker node"
  type        = string
}

variable "region" {
  description = "Name of arvan abrak region for worker node"
  type = string
}

variable "flavor_id" {
  description = "PlanID for worker node"
  type = string
}

variable "key_name" {
  description = "SSH key name in my account"
  type = string
}

variable "image_name" {
  description = "Image name for worker node"
  type = string
}

variable "disk_size" {
  description = "Disk size for worker node"
  type = string
}
