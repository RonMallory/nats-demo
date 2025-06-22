module "network" {
  source = "../../modules/network"

  env      = var.env
  stack    = var.stack
  app      = var.app
  region   = var.region
  az_count = var.az_count
  vpc_cidr = var.vpc_cidr
}
