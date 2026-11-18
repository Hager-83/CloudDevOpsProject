output "vpc_id" {
  description = "Project VPC ID"
  value       = module.network.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.network.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = module.network.private_subnet_ids
}

output "ecr_repository_urls" {
  description = "ECR repository URLs for application services"
  value       = module.ecr.repository_urls
}

output "github_actions_role_arn" {
  description = "IAM role used by GitHub Actions to push images to ECR"
  value       = module.github_oidc.role_arn
}