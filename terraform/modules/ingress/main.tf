resource "helm_release" "ingress-nginx" {
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "kube-system"
  create_namespace = false
  force_update     = true
  replace          = true
  atomic           = true
}

resource "kubernetes_ingress_v1" "grafana" {
  depends_on = [
    helm_release.ingress-nginx
  ]
   metadata {
      name        = "grafana"
      namespace = "monitoring"
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