terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.20.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.1"
    }

    helm={}
  }
}
data "terraform_remote_state" "eks" {
  backend = "remote"
  
  config = {
    organization = "Cisco-IST-TigerTeam"
    workspaces = {
      name = "Marks-EKS-2"
    }
  }
}

provider "aws" {
  region = "us-west-1"
}
data "aws_eks_cluster" "cluster" {
  name = "marks_k8s2-g8bu3uBd"
  # name = data.terraform_remote_state.eks.outputs.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    command     = "aws"
    args = [
      "eks",
      "get-token",
      "--cluster-name",
      data.aws_eks_cluster.cluster.name
    ]
  }
}
