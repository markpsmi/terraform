provider "intersight" {
  apikey        = var.apikey
  secretkey     = var.secretkey
  endpoint      = var.endpoint
}

data "intersight_kubernetes_cluster" "Marks_iks_cluster2" {
  name = "Marks_iks_cluster2"
}

provider "helm" {
  kubernetes {
   host                   = yamldecode(base64decode(data.intersight_kubernetes_cluster.Marks_iks_cluster2.results.0.kube_config)).clusters.0.cluster.server
  cluster_ca_certificate = base64decode(yamldecode(base64decode(data.intersight_kubernetes_cluster.Marks_iks_cluster2.results.0.kube_config)).clusters.0.cluster.certificate-authority-data)
  client_certificate     = base64decode(yamldecode(base64decode(data.intersight_kubernetes_cluster.Marks_iks_cluster2.results.0.kube_config)).users[0].user.client-certificate-data)
  client_key             = base64decode(yamldecode(base64decode(data.intersight_kubernetes_cluster.Marks_iks_cluster2.results.0.kube_config)).users[0].user.client-key-data)
  }
}

resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress-controller"

  repository = "https://charts.bitnami.com/bitnami"
  chart      = "nginx-ingress-controller"

  set {
    name  = "service.type"
    value = "ClusterIP"
  }
}
