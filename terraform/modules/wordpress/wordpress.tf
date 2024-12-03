resource "kubernetes_service" "wordpress-service" {
  depends_on = [
    kubernetes_service.mysql-service
  ]
 metadata {
   name = "wordpress"
   namespace = var.namespace
   labels = local.wordpress_labels
 }
 spec {
   selector = local.wordpress_labels
   port {
     name = "web"
     port        = 8080
     target_port = 8080
   }
   type = "LoadBalancer"
 }
}

resource "kubernetes_config_map" "openresty-proxy-conf" {
  metadata {
    name      = "openresty-proxy-conf"
    namespace = var.namespace
  }

  data = {
    "proxy.conf" = "${file("${path.module}/openresty/proxy.conf")}"
  }
}

resource "kubernetes_deployment" "wordpress" {
 metadata {
   name = "wordpress"
   labels = local.wordpress_labels
   namespace = var.namespace
 }
 spec {
   replicas = 3
   selector {
     match_labels = local.wordpress_labels
   }
   template {
     metadata {
       labels = local.wordpress_labels
     }
     spec {
       container {
         image = "ghcr.io/katzefudder/wordpress:latest"
         name  = "wordpress"
         port {
            name = "web"
            container_port = 80
         }
         env {
            name = "WORDPRESS_DB_HOST"
            value = "mysql"
         }
         env {
             name = "WORDPRESS_DB_NAME"
             value = "wordpress"
         }
         env {
            name = "WORDPRESS_DB_USER"
            value = "root"
         }
         env {
           name = "WORDPRESS_DB_PASSWORD"
           value_from {
             secret_key_ref {
               name = "mysql-pass"
               key = "password"
             }
           }
         }
       }
       container {
         image = "ghcr.io/katzefudder/openresty:latest"
         name  = "openresty"
         port {
            name = "monitoring"
            container_port = 8080
         }
         volume_mount {
            mount_path = "/etc/nginx/conf.d"
            name       = "openresty-conf"
         }
       }
       volume {
          name = "openresty-conf"
          config_map {
            name = kubernetes_config_map.openresty-proxy-conf.metadata.0.name
          }
        }
     }
   }
 }
}