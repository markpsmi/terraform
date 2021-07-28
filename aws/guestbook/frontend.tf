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
