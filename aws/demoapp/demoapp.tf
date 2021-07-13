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
      name = "Marks-EKS"
    }
  }
}

provider "aws" {
  region = data.terraform_remote_state.eks.outputs.region
}
data "aws_eks_cluster" "cluster" {
  name = data.terraform_remote_state.eks.outputs.cluster_id
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

provider "helm" {
kubernetes {
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

}

resource "helm_release" "mongodb" {
  name       = "mongodb"
  verify    = false
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "mongodb"

  set {
    name  = "service.type"
    value = "ClusterIP"
  }

  set {
    name = "auth.rootPassword"
    value = var.rootPassword
  }

  set {
    name = "auth.password"
    value = var.password
  }
  set {
    name = "auth.username"
    value = var.username
  }
  set {
    name = "auth.database"
    value = var.database
  }
  set {
    name = "auth.replicaSetKey"
    value = var.replicaSetKey
  }


}

resource "kubernetes_deployment" "covid" {
  metadata {
    name = "covid"
    labels = {
      app = "covid"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "covid"
      }
    }

    template {
      metadata {
        labels = {
          app = "covid"
        }
      }

      spec {
        container {
          image = "603010903084.dkr.ecr.us-east-2.amazonaws.com/covid"
          name  = "covid"
          env {
            name = "COVIDDB"
            value = "mongodb"
          }
          }
        }
      }
    }
}

resource "kubernetes_service" "covid-service" {
  metadata {
    name = "covid"
  }

  spec {
    selector = {
      app = "covid"
    }
    type             = "LoadBalancer"

    port {
      port        = 80
      target_port = 5000
    }
  }

  wait_for_load_balancer = "true"
}

output "lb_ip" {
  value = kubernetes_service.covid-service.status.0.load_balancer.0.ingress.0.hostname
}
