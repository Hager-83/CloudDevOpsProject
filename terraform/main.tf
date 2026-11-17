module "network" {
  source = "./modules/network"

  project_name = var.project_name
  vpc_cidr     = "10.0.0.0/16"
}

module "ecr" {
  source = "./modules/ecr"

  project_name = var.project_name

  services = [
    "auth-service",
    "frontend",
    "roadmap-service"
  ]
}