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
    type = "LoadBalancer"     
    port {
      port        = 6379
    }
  }
}
