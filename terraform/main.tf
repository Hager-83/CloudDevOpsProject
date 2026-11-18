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

module "eks" {
  source = "./modules/eks"

  project_name       = var.project_name
  private_subnet_ids = module.network.private_subnet_ids
  admin_cidr         = var.admin_cidr

  depends_on = [module.network]
}

module "github_oidc" {
  source = "./modules/github-oidc"

  project_name        = var.project_name
  github_repository   = "Hager-83/CloudDevOpsProject"
  github_branch       = "main"
  ecr_repository_arns = values(module.ecr.repository_arns)
}