terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
     local = {
      source  = "hashicorp/local"
      version = "~> 2.4"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}


locals {
  ansible_commander_config = jsondecode(file("${path.module}/infra_configs/ansible-commander-config.json"))
  k8s_master_config   = jsondecode(file("${path.module}/infra_configs/k8s-master-config.json"))
  k8s_worker_config   = jsondecode(file("${path.module}/infra_configs/k8s-worker-config.json"))
}

module "ansible_commander" {
  source = "./modules/server"
  config = local.ansible_commander_config
}

module "k8s_master" {
  source = "./modules/server"
  config = local.k8s_master_config
}

module "k8s_worker" {
  source = "./modules/server"
  config = local.k8s_worker_config
}