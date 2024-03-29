resource "kubernetes_ingress_v1" "wordpress" {
   metadata {
      name        = "wordpress"
      namespace = var.namespace
      annotations = {
        "nginx.ingress.kubernetes.io/rewrite-target" = "/"
        "nginx.ingress.kubernetes.io/affinity" = "cookie"
        "nginx.ingress.kubernetes.io/session-cookie-name" = "sticky-session"
        "nginx.ingress.kubernetes.io/session-cookie-expires" = "172800"
        "nginx.ingress.kubernetes.io/session-cookie-max-age" = "172800"
      }
   }
   spec {
    ingress_class_name = "nginx"
      rule {
        host = var.hostname
        http {
         path {
           path = "/"
           path_type = "Prefix"
           backend {
             service {
               name = "wordpress"
               port {
                 name = "web"
               }
             }
           }
        }
      }
    }
  }
}