module "monitoring" {
  source = "./modules/monitoring"
}

module "wordpress" {
  source = "./modules/wordpress"
  stage = var.stage
}

module "ingress" {
  source = "./modules/ingress"
}

module "dashboard" {
  source = "./modules/dashboard"
}