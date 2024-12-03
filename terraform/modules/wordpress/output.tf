output "mysql_service_id" {
  value = kubernetes_service.mysql-service.id
}

output "wordpress_service_id" {
  value = kubernetes_service.wordpress-service.id
}