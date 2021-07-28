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
    
    port {
      port = 6379
      target_port = 6379
    }
  }
}
