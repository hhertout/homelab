terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    bucket = "homelab-terraform-state"
    key    = "pg/terraform.tfstate"
    region = "eu-west-1"
  }
}

provider "kubernetes" {
  host                   = var.kube_host
  cluster_ca_certificate = base64decode(var.kube_ca_certificate)
  token                  = var.kube_token
}

provider "helm" {
  kubernetes = {
    host                   = var.kube_host
    cluster_ca_certificate = base64decode(var.kube_ca_certificate)
    token                  = var.kube_token
  }
}
