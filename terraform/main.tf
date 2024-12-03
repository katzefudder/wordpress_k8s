resource "kubernetes_namespace" "wordpress" {
  metadata {
    name = "${var.stage}-wordpress"
  }
}

resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "${var.stage}-monitoring"
  }
}

module "monitoring" {
  depends_on = [module.ingress]
  namespace = kubernetes_namespace.monitoring.metadata[0].name
  source = "./modules/monitoring"
}
module "ingress" {
  source = "./modules/ingress"
  namespace = kubernetes_namespace.wordpress.metadata[0].name
}

module "wordpress" {
  depends_on = [module.monitoring]
  source = "./modules/wordpress"
  stage = var.stage
  hostname = var.hostname
  namespace = kubernetes_namespace.wordpress.metadata[0].name
}

module "dashboard" {
  depends_on = [module.monitoring]
  source = "./modules/dashboard"
  namespace = kubernetes_namespace.wordpress.metadata[0].name
}