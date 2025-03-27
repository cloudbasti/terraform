# outputs.tf in your root module

# Output the instance details for SSH config
output "ansible_commander_hostname" {
  value = module.ansible_commander.instance_public_ip
}

output "k8s_master_hostname" {
  value = module.k8s_master.instance_public_ip
}

output "k8s_worker_hostname" {
  value = module.k8s_worker.instance_public_ip
}

# Generate SSH config file
resource "local_file" "ssh_config" {
  content = <<-EOT
# Auto-generated SSH config - DO NOT EDIT MANUALLY

Host ansible-commander
    HostName ${module.ansible_commander.instance_public_ip}
    User ubuntu
    IdentityFile ~/.ssh/aws_secrets/aws-ansible-commander
    StrictHostKeyChecking no

Host k8s-master
    HostName ${module.k8s_master.instance_public_ip}
    User ubuntu
    IdentityFile ~/.ssh/aws_secrets/aws-k8s-master
    StrictHostKeyChecking no

Host k8s-worker
    HostName ${module.k8s_worker.instance_public_ip}
    User ubuntu
    IdentityFile ~/.ssh/aws_secrets/aws-k8s-worker
    StrictHostKeyChecking no
  EOT
  filename = "${path.module}/outputs/generated_ssh_config"
}

# Generate inventory.yml for Ansible with the correct format
resource "local_file" "inventory" {
  content = <<-EOT
---
k8_master:
  hosts:
    master:
      ansible_host: ${module.k8s_master.instance_public_ip}
      ansible_user: ubuntu
      ansible_ssh_private_key_file: ~/.ssh/aws_secrets/aws-k8s-master

k8_worker:
  hosts:
    worker:
      ansible_host: ${module.k8s_worker.instance_public_ip}
      ansible_user: ubuntu
      ansible_ssh_private_key_file: ~/.ssh/aws_secrets/aws-k8s-worker
  EOT
  filename = "${path.module}/outputs/inventory.yml"
}