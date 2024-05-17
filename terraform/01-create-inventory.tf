resource "null_resource" "ansible-provision" {

  depends_on = ["arvan_iaas_abrak.master_node","module.worker_nodes"]

  ##Create Masters Inventory
  provisioner "local-exec" {
    command =  "echo \"[kube-master]\n${arvan_iaas_abrak.master_node.name} ansible_ssh_host=${arvan_iaas_abrak.master_node.addresses[0]}\" > ../kargo/inventory/inventory"
  }

  ##Create ETCD Inventory
  provisioner "local-exec" {
    command =  "echo \"\n[etcd]\n${arvan_iaas_abrak.master_node.name} ansible_ssh_host=${arvan_iaas_abrak.master_node.addresses[0]}\" >> ../kargo/inventory/inventory"
  }

  ##Create Nodes Inventory
  provisioner "local-exec" {
    command =  "echo \"\n[kube-node]\" >> ../kargo/inventory/inventory"
  }
  provisioner "local-exec" {
    command =  "echo \"${join("\n", [for node in module.worker_nodes : format("%s ansible_ssh_host=%s", node.worker_node_detail.name, node.worker_node_detail.addresses[0])])}\" >> ../kargo/inventory/inventory"
  }

  provisioner "local-exec" {
    command =  "echo \"\n[k8s-cluster:children]\nkube-node\nkube-master\" >> ../kargo/inventory/inventory"
  }
}
