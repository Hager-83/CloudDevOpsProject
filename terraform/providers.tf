provider "aws" {
  region = var.aws_region

  allowed_account_ids = ["211017377170"]

  default_tags {
    tags = {
      Project   = var.project_name
      ManagedBy = "Terraform"
    }
  }
}