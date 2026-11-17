variable "project_name" {
  description = "Prefix for network resource names"
  type        = string
}

variable "vpc_cidr" {
  description = "IPv4 CIDR block for the VPC"
  type        = string
}