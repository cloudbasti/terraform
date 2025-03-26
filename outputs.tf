# outputs.tf in your root module

# Output the instance details for SSH config
output "commander_hostname" {
  value = module.commander.instance_public_ip
}

output "kube_master_hostname" {
  value = module.kube_master.instance_public_ip
}

output "kube_worker_hostname" {
  value = module.kube_worker.instance_public_ip
}

# Generate SSH config file
resource "local_file" "ssh_config" {
  content = <<-EOT
# Auto-generated SSH config - DO NOT EDIT MANUALLY

Host commander
    HostName ${module.commander.instance_public_ip}
    User ubuntu
    IdentityFile ${path.root}/../keys/aws_ansible_control_node
    StrictHostKeyChecking no

Host kube-master
    HostName ${module.kube_master.instance_public_ip}
    User ubuntu
    IdentityFile ${path.root}/../keys/aws_kubernetes_master_key
    StrictHostKeyChecking no

Host kube-worker
    HostName ${module.kube_worker.instance_public_ip}
    User ubuntu
    IdentityFile ${path.root}/../keys/aws_kubernetes_worker
    StrictHostKeyChecking no
  EOT
  filename = "${path.module}/outputs/generated_ssh_config"
}

# Generate inventory.yml for Ansible with the correct format
resource "local_file" "inventory" {
  content = <<-EOT
---
k8s_masters:
  hosts:
    master:
      ansible_host: ${module.kube_master.instance_public_ip}
      ansible_user: ubuntu
      ansible_ssh_private_key_file: ~/.ssh/aws_kubernetes_master

k8s_workers:
  hosts:
    worker:
      ansible_host: ${module.kube_worker.instance_public_ip}
      ansible_user: ubuntu
      ansible_ssh_private_key_file: ~/.ssh/aws_kubernetes_worker
  EOT
  filename = "${path.module}/outputs/inventory.yml"
  
}