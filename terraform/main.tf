module "monitoring" {
  source = "./modules/monitoring"
}

module "ingress" {
  source = "./modules/ingress"
}

module "wordpress" {
  source = "./modules/wordpress"
  stage = var.stage
}

module "dashboard" {
  source = "./modules/dashboard"
}