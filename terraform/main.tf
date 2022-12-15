module "monitoring" {
  depends_on = [module.ingress]
  source = "./modules/monitoring"
}

module "ingress" {
  source = "./modules/ingress"
}

module "wordpress" {
  depends_on = [
    module.monitoring
  ]
  source = "./modules/wordpress"
  stage = var.stage
  hostname = var.hostname
}

module "dashboard" {
  source = "./modules/dashboard"
}