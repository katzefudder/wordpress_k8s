resource "kubernetes_ingress_v1" "grafana" {
   metadata {
      name        = "grafana"
      namespace = var.namespace
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
               name = "kube-prometheus-stack-grafana"
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

resource "kubernetes_ingress_v1" "prometheus" {
   metadata {
      name        = "prometheus"
      namespace = var.namespace
      annotations = {
        "nginx.ingress.kubernetes.io/rewrite-target" = "/"
      }
   }
   spec {
    ingress_class_name = "nginx"
      rule {
        host = "prometheus.localhost"
        http {
         path {
           path = "/"
           path_type = "Prefix"
           backend {
             service {
               name = "kube-prometheus-stack-prometheus"
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