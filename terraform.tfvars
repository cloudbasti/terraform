
server_configs = {
  
  commander = {
    key_name            = "aws_ansible_control_node"
    security_group_name = "ansible_control_node-sg"
    ami                 = "ami-0084a47cc718c111a"
    instance_type       = "t2.micro"
    instance_name       = "Commander"
    public_key_path     = "./keys/aws_ansible_control_node.pub"
    user_data_path      = "./scripts/ansible_node_setup.sh"
    ingress_rules       = [
      {
        description = "HTTPS"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
    tags                = {
      Role        = "AnsibleController"
      Environment = "Production"
    }
  },
  
  # Kubernetes master configuration
  kube_master = {
    key_name            = "aws_kubernetes_master_key"
    security_group_name = "kubernetes-master-sg"
    ami                 = "ami-03250b0e01c28d196"
    instance_type       = "t2.medium"
    instance_name       = "KubernetesMaster"
    public_key_path     = "./keys/aws_kubernetes_master.pub"
    user_data_path      = "./scripts/kubernetes_master_setup.sh"
    ingress_rules       = [
      {
        description = "Kubernetes API"
        from_port   = 6443
        to_port     = 6443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
    tags                = {
      Role        = "KubernetesControl"
      Environment = "Production"
    }
  },
  
  # Kubernetes worker configuration
  kube_worker = {
    key_name            = "aws_kubernetes_worker"
    security_group_name = "kubernetes-worker-sg"
    ami                 = "ami-03250b0e01c28d196"
    instance_type       = "t2.medium"
    instance_name       = "KubernetesWorker"
    public_key_path     = "./keys/aws_kubernetes_worker.pub"
    user_data_path      = "./scripts/kubernetes_worker_setup.sh"
    ingress_rules       = [
      {
        description = "Kubelet API"
        from_port   = 10250
        to_port     = 10250
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        description = "NodePort Services"
        from_port   = 30000
        to_port     = 32767
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
    tags                = {
      Role        = "KubernetesWorker"
      Environment = "Production"
    }
  }
}