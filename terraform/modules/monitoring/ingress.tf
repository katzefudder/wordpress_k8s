/*
resource "kubernetes_ingress_v1" "grafana" {
   metadata {
      name        = "monitoring"
      namespace = kubernetes_namespace.monitoring.metadata.0.name
      annotations = {
        "nginx.ingress.kubernetes.io/rewrite-target" = "/grafana/$2"
      }
   }
   spec {
    ingress_class_name = "nginx"
    rule {
        http {
         path {
           path = "/grafana(/|$)(.*)"
           path_type = "Prefix"
           backend {
             service {
               name = "prometheus-community-grafana"
               port {
                 number = 80
               }
             }
           }
        }
      }
    }
  }
}
*/