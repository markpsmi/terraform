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
          value = "env"
        }
        env {
          name = "REDIS_FOLLOWER_SERVICE_HOST"
          #value = var.redis_follower_host
          value = "a71e4a9415331430ea533f3532e0ec59-2066399134.us-west-1.elb.amazonaws.com"
        }  
        env {
          name = "REDIS_LEADER_SERVICE_HOST"
          #value = var.redis_leader_host
          value = "a90683ff442b74c459ac54bf4e9a704d-839547321.us-west-1.elb.amazonaws.com"
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
