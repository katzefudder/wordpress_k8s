resource "kubernetes_ingress_v1" "grafana" {
   metadata {
      name        = "grafana"
      namespace = kubernetes_namespace.monitoring.metadata[0].name
      annotations = {
        "nginx.ingress.kubernetes.io/rewrite-target" = "/"
      }
   }
   spec {
    ingress_class_name = "nginx"
      rule {
        host = "grafana.localhost"
        http {
         path {
           path = "/"
           path_type = "Prefix"
           backend {
             service {
               name = "prometheus-community-grafana"
               port {
                 name = "http-web"
               }
             }
           }
        }
      }
    }
  }
}