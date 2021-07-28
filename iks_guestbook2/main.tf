provider "intersight" {
  apikey        = var.apikey
  secretkey     = var.secretkey
  endpoint      = var.endpoint
}

data "intersight_kubernetes_cluster" "Expedia-iks" {
  name = "Expedia-iks"
}

provider "kubernetes" {

  host                   = yamldecode(base64decode(data.intersight_kubernetes_cluster.Expedia-iks.results.0.kube_config)).clusters.0.cluster.server
  cluster_ca_certificate = base64decode(yamldecode(base64decode(data.intersight_kubernetes_cluster.Expedia-iks.results.0.kube_config)).clusters.0.cluster.certificate-authority-data)
  client_certificate     = base64decode(yamldecode(base64decode(data.intersight_kubernetes_cluster.Expedia-iks.results.0.kube_config)).users[0].user.client-certificate-data)
  client_key             = base64decode(yamldecode(base64decode(data.intersight_kubernetes_cluster.Expedia-iks.results.0.kube_config)).users[0].user.client-key-data)
}
resource "kubernetes_deployment" "frontend" {


  metadata {
    name = "frontend"
    labels = {
      app = "guestbook"
      tier = "frontend"
    }
  }  
  spec {
    replicas = 1

    selector {
      match_labels = {
        app  = "guestbook"
        tier = "frontend"
      }
    }
    template {
      metadata {
        labels = {
          app = "guestbook"
          tier = "frontend"                  
        }
      }

      spec {
        container {
          image = "gcr.io/google_samples/gb-frontend:v5"
          name  = "php-redis"
       
         env {
          name = "GET_HOST_FROM"
          value = "dns"
        }
        resources {
            requests = {
              cpu    = "100m"
              memory = "100Mi"
            } 
          }             
          port {
          container_port = "80"
          }         
        }                 
      }
    }
  }
}
resource "kubernetes_service" "frontend" {

  metadata {
    name = "frontend"
    labels = {
      app = "guestbook"
      tier = "frontend"
    }   
  }
  spec {
    selector = {
      app = "guestbook"
      tier = "frontend"
    }
    type = "LoadBalancer"

    port {
      port        = 80
    }
  }
}
resource "kubernetes_deployment" "follower" {
  metadata {
    name = "redis-follower"
    labels = {
      app = "redis"
      role = "follower"
      tier = "backend"
    }
  }  
  spec {
    replicas = 2

    selector {
      match_labels = {
        app  = "redis"
      }
    }

    template {
      metadata {
        labels = {
          app = "redis"
          role = "follower"
          tier = "backend"                  
        }
      }

      spec {
        container {
          image = "gcr.io/google_samples/gb-redis-follower:v2"
          name  = "follower"

          resources {
            requests = {
              cpu    = "100m"
              memory = "100Mi"
            } 
          }             
          port {
          container_port = "6379"
          }         
        }                 
      }
    }
  }
}

resource "kubernetes_service" "follower" {
  metadata {
    name = "redis-follower"
    labels = {
      app = "redis"
      role = "follower"
      tier = "backend"
    }   
  }
  spec {
    selector = {
      app = "redis"
      role = "follower"
      tier = "backend"
    }
    #type = "LoadBalancer"
    port {
      port        = 6379
    }
  }
}
resource "kubernetes_deployment" "leader" {
  metadata {
    name = "redis-leader"
    labels = {
      app = "redis"
      role = "leader"
      tier = "backend"
    }
  }  
  spec {
    replicas = 1

    selector {
      match_labels = {
        app  = "redis"
      }
    }

    template {
      metadata {
        labels = {
          app = "redis"
          role = "leader"
          tier = "backend"                  
        }
      }

      spec {
        container {
          image = "docker.io/redis:6.0.5"
          name  = "follower"

          resources {
            requests = {
              cpu    = "100m"
              memory = "100Mi"
            } 
          }             
          port {
          container_port = "6379"
          }         
        }                 
      }
    }
  }
}
resource "kubernetes_service" "leader" {
  metadata {
    name = "redis-leader"
    labels = {
      app = "redis"
      role = "leader"
      tier = "backend"
    }   
  }
  spec {
    selector = {
      app = "redis"
      role = "leader"
      tier = "backend"
    }
    #type = "LoadBalancer"
    port {
      port = 6379
      target_port = 6379
    }
  }
}
