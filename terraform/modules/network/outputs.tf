output "vpc_id" {
  description = "Project VPC ID"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "Public subnet IDs ordered by zone key"
  value = [
    for key in sort(keys(aws_subnet.public)) :
    aws_subnet.public[key].id
  ]
}

output "private_subnet_ids" {
  description = "Private subnet IDs ordered by zone key"
  value = [
    for key in sort(keys(aws_subnet.private)) :
    aws_subnet.private[key].id
  ]
}