output "repository_urls" {
  description = "Repository URLs indexed by service name"
  value = {
    for service, repository in aws_ecr_repository.main :
    service => repository.repository_url
  }
}

output "repository_arns" {
  description = "Repository ARNs indexed by service name"
  value = {
    for service, repository in aws_ecr_repository.main :
    service => repository.arn
  }
}