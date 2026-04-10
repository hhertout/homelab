terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    bucket = "amzn-s3-us-east-1-terraform-01"
    key    = "kube-internal-monitoring/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "helm" {
  kubernetes = {
    host                   = var.kube_host
    cluster_ca_certificate = base64decode(var.kube_ca_certificate)
    token                  = var.kube_token
  }
}
