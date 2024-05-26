output "master_node_detail" {
  description = "The detail of the master node"
  value       = arvan_iaas_abrak.master_node
}

output "worker_nodes_detail" {
  description = "The detail of the worker nodes"
  value       = [for node in module.worker_nodes : node.worker_node_detail]
}
