variable "project_name" {
  type = string
}

variable "github_repository" {
  description = "GitHub repository in owner/repository format"
  type        = string
}

variable "github_branch" {
  type    = string
  default = "main"
}

variable "ecr_repository_arns" {
  description = "ECR repositories that GitHub Actions can push images to"
  type        = list(string)
}