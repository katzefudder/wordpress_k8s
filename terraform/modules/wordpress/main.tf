locals {
 wordpress_labels = {
   "app.kubernetes.io/name" = "wordpress"
   prometheus = "true"
 }
 mysql_labels = {
   "app.kubernetes.io/name" = "mysql"
 }
}

module "monitoring" {
  source = "./monitoring"
  namespace = "${var.stage}-wordpress"
}