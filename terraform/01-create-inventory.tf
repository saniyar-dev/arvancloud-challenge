resource "null_resource" "ansible-provision" {

  depends_on = ["arvan_iaas_abrak.master_node","module.worker_nodes"]

  ##Create Masters Inventory
  provisioner "local-exec" {
    command =  "echo \"[kube-master]\n${arvan_iaas_abrak.master_node.name} ansible_ssh_host=${arvan_iaas_abrak.master_node.addresses[0]}\" > ../kubespray/inventory/inventory"
  }

  ##Create ETCD Inventory
  provisioner "local-exec" {
    command =  "echo \"\n[etcd]\n${arvan_iaas_abrak.master_node.name} ansible_ssh_host=${arvan_iaas_abrak.master_node.addresses[0]}\" >> ../kubespray/inventory/inventory"
  }

  ##Create Nodes Inventory
  provisioner "local-exec" {
    command =  "echo \"\n[kube-node]\" >> ../kubespray/inventory/inventory"
  }
  provisioner "local-exec" {
    command =  "echo \"${join("\n", [for node in module.worker_nodes : format("%s ansible_ssh_host=%s", node.worker_node_detail.name, node.worker_node_detail.addresses[0])])}\" >> ../kubespray/inventory/inventory"
  }

  provisioner "local-exec" {
    command =  "echo \"\n[k8s-cluster:children]\nkube-node\nkube-master\" >> ../kubespray/inventory/inventory"
  }

  provisioner "local-exec" {
    command = "source ../ansible-venv/bin/activate"
  }

  provisioner "local-exec" {
    command = "cp -rfp ../kubespray/inventory/sample ../kubespray/inventory/mycluster"
  }

  provisioner "local-exec" {
    command = "declare -a IPS=(${join(" ", [for node in module.worker_nodes : node.worker_node_detail.addresses[0]], arvan_iaas_abrak.master_node.addresses[0])}) && CONFIG_FILE=inventory/mycluster/hosts.yaml python3 contrib/inventory_builder/inventory.py ${IPS[@]}"
  }
}
