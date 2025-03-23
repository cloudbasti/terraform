terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}


module "commander" {
  source = "./modules/server"
  config = var.server_configs["commander"]
}

module "kube_master" {
  source = "./modules/server"
  config = var.server_configs["kube_master"]
}

module "kube_worker" {
  source = "./modules/server"
  config = var.server_configs["kube_worker"]
}