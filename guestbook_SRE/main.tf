provider "kubernetes" {
  config_path    = ""
  config_context = "my-context"
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
    replicas = 3

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
